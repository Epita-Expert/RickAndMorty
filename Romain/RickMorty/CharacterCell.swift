//
//  CharacterCell.swift
//  RickMorty
//
//  Created by Nathan Podesta on 25/11/2022.
//

import UIKit

class CharacterCell: UITableViewCell {
    static let defaultHeight: CGFloat = 100
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var RMImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayChar(char: RMCharacter) {
        // display whatever properties needed
        let urlString = char.image
        guard let url = URL(string: urlString) else { return }
        
        RMImage.af.setImage(withURL: url)
        originLabel.text = char.origin.name
        speciesLabel.text = char.species
        nameLabel.text = char.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
