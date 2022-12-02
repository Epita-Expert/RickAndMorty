//
//  DetailViewViewController.swift
//  RickMorty
//
//  Created by Nathan Podesta on 25/11/2022.
//

import UIKit

class DetailViewViewController: UIViewController {

    var plouf: RMCharacter?
    @IBOutlet weak var imagePlouf: UIImageView!
    @IBOutlet weak var labelPlouf: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = plouf?.image else { return }
        guard let url = URL(string: urlString) else { return }
        
        imagePlouf.af.setImage(withURL: url)
        labelPlouf.text = plouf?.species
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
}
