//
//  ActivityCollectionViewCell.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/5/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    
    //var textLabel: UILabel!
    var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        /*textLabel = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height / 2) - 9, width: self.frame.size.width, height: 18))
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)*/
        
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        image.center = self.contentView.center
        contentView.addSubview(image)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
