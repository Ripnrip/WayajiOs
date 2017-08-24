//
//  RatingScoreTableViewCell.swift
//  Wayaj
//
//  Created by Admin on 8/24/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class RatingScoreTableViewCell: UITableViewCell {

    @IBOutlet var scoreBar: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var percentLabel: UILabel!
    var type:RatingType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
