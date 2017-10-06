//
//  BucketListCollectionViewCell.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/5/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class BucketListCollectionViewCell: UICollectionViewCell {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height / 2) - 9, width: self.frame.size.width, height: 18))
        title.textColor = .white
        //title.backgroundColor = .black
        title.font = UIFont.systemFont(ofSize: 13)
        title.textAlignment = .center
        //title.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.contentView.addSubview(title)
        
        //textLabel = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height / 2) - 9, width: self.frame.size.width, height: 18))
        //textLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
