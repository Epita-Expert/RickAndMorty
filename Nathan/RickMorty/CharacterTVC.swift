//
//  CharacterTVC.swift
//  RickMorty
//
//  Created by Nathan Podesta on 25/11/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class CharacterTVC: UITableViewController, UITableViewDataSourcePrefetching {
    var characters: [RMCharacter] = []
    private let cellName = "augusteCell"
    private var isFetchInProgress = false
    private var apiUrl: String? = "https://rickandmortyapi.com/api/character"

    override func viewDidLoad() {
        downloadAndParse()
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellName)
        self.tableView.prefetchDataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.characters.count
    }
    
//    private func downloadAndParse() {
//        //checking if we are already downloading and if we still have something to download
//        guard isFetchInProgress == false && apiUrl != nil else {
//            return
//        }
//        isFetchInProgress = true
//        AF.request(url).validate().responseDecodable(of: RMCharacterResponse.self) { response in
//            switch response.result {
//                case .success(let character):
//                    debugPrint(character)
//                    self.characters = character
//                    self.tableView.reloadData()
//                case .failure(let e):
//                    debugPrint(e)
//                    return
//            }
//        }
//    }
    
    private func downloadAndParse() {
        //checking if we are already downloading and if we still have something to download
        guard isFetchInProgress == false && apiUrl != nil else {
            return
        }
        isFetchInProgress = true
        AF.request(apiUrl!)
            .validate()
            .responseDecodable(of: RMCharacterResponse.self) { response in
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
    
    private func reloadAfterFetching(newRowsCount: Int) {
        self.isFetchInProgress = false
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? CharacterCell else { fatalError("missing cell") }
        cell.displayChar(char: self.characters[indexPath.row])
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goPlouf", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goPlouf" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let detailVC = segue.destination as? DetailViewViewController else {
                 return
            }
            // Get the new view controller using segue.destination.
            let characters = characters[indexPath.row]
            // Pass the selected object to the new view controller.
            detailVC.plouf = characters
         }
    }
    
    // MARK: - Prefetch
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        debugPrint(indexPaths)
        let lastIndexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
        
        if indexPaths.contains(lastIndexPath) {
            downloadAndParse()
        }
    }
}
