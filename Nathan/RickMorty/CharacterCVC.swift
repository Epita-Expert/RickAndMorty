//
//  CharacterCVC.swift
//  RickMorty
//
//  Created by Nathan Podesta on 08/12/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class CharacterCVC: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    private let itemsPerRow: CGFloat = 2
    private let lineSpacing: CGFloat = 12
    private let itemSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 15.0,
        bottom: 15.0,
        right: 15.0
    )
    
    var characters: [RMCharacter] = []
    private let nibNameTest = "CharacterCollectionCell"
    private let cellName = "Cell"
    private var isFetchInProgress = false
    private var apiUrl: String? = "https://rickandmortyapi.com/api/character"

    override func viewDidLoad() {
        downloadAndParse()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let cellNib = UINib(nibName: nibNameTest, bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: cellName)
        
        // MANDATORY FOR prefetchItemsAt
        self.collectionView.prefetchDataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CharacterCollectionCell? else { fatalError("missing cell") }
        
        // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.displayChar(char: self.characters[indexPath.row])
        // Configure the cell
    
        return cell
    }
    
    private func downloadAndParse() {
        //checking if we are already downloading and if we still have something to download
        guard isFetchInProgress == false && apiUrl != nil else {
            return
        }
        isFetchInProgress = true
        
        AF.request(apiUrl!).validate().responseDecodable(of: RMCharacterResponse.self) { response in
            switch response.result {
            case .success(let charResponse):
                debugPrint(charResponse)
                //append instead of replacing all the content
                self.characters.append(contentsOf: charResponse.results)
                //TODO : update your apiUrl from the charResponse.info
                self.apiUrl = charResponse.info.next
                //smart reloading
                self.reloadAfterFetching(newRowsCount: charResponse.results.count)
            case .failure(_):
                return
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goPlouf", sender: indexPath)
    }
    
    private func reloadAfterFetching(newRowsCount: Int) {
        self.isFetchInProgress = false
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goPlouf" {
//            guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
            guard let detailVC = segue.destination as? DetailViewViewController else {
                 return
            }
            let indexPath = sender as! NSIndexPath
            
            // Get the new view controller using segue.destination.
            let characters = characters[indexPath.row]
            // Pass the selected object to the new view controller.
            detailVC.plouf = characters
         }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        debugPrint(indexPaths)
        let lastIndexPath = IndexPath(row: self.collectionView.numberOfItems(inSection: 0) - 1, section: 0)
        
        if indexPaths.contains(lastIndexPath) {
            downloadAndParse()
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension CharacterCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = itemSpacing * (itemsPerRow - 1) + sectionInsets.left + sectionInsets.right
        let availableWidth = view.frame.width - paddingSpace
        let width = (availableWidth / itemsPerRow).rounded(.towardZero)
        let height = (width * 2.0 / 3.0).rounded(.towardZero)
        return CGSize(width: width, height: height)
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        self.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
