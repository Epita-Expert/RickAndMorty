//
//  CharacterCollectionCell.swift
//  RickMorty
//
//  Created by Nathan Podesta on 08/12/2022.
//

import UIKit

class CharacterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayChar(char: RMCharacter) {
        // display whatever properties needed
        let urlString = char.image
        guard let url = URL(string: urlString) else { return }
        nameLabel.text = char.name
        image.af.setImage(withURL: url)
    }
}
