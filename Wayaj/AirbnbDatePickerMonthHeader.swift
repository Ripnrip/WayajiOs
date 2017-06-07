//
//  AirbnbDatePickerMonthHeader.swift
//  airbnb-datepicker
//
//  Created by Yonas Stephen on 23/2/17.
//  Copyright © 2017 Yonas Stephen. All rights reserved.
//

import UIKit

class AirbnbDatePickerMonthHeader: UICollectionViewCell {

    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     func setupViews() {
        addSubview(monthLabel)
        
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
