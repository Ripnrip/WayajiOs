//
//  OfferTableViewCell.swift
//  Wayaj
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    var isSaved = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func saveOffer(_ sender: Any) {
        
        if isSaved == false {
            isSaved = true
            heartButton.setImage(UIImage(named: "greenHeart"), for: .normal)
        } else {
            isSaved = false
            heartButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
        }
    }
    

}
