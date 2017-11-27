//
//  UserImageCollectionViewCell.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 11/26/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class UserImageCollectionViewCell: UICollectionViewCell {
    
    var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        /*textLabel = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height / 2) - 9, width: self.frame.size.width, height: 18))
         textLabel.font = UIFont.systemFont(ofSize: 13)
         textLabel.textColor = .white
         textLabel.textAlignment = .center
         contentView.addSubview(textLabel)*/
        
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image.center = self.contentView.center
        contentView.addSubview(image)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
