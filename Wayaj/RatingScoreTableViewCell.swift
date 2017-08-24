//
//  RatingScoreTableViewCell.swift
//  Wayaj
//
//  Created by Admin on 8/24/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Popover

class RatingScoreTableViewCell: UITableViewCell {

    @IBOutlet var scoreBar: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var percentLabel: UILabel!
    var type:RatingType?
    var popUpString:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func presentPopUp(_ sender: Any) {
        let startPoint = infoButton.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        txtLabel.text = popUpString
    
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
    }

}
