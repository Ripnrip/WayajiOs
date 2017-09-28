//
//  CustomWayajAnnotationView.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 9/28/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import MapKit

class CustomWayajAnnotationView: MKAnnotationView {
    
    var listing:Listing = Listing()
    
    //let selectedLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 50, height: 38))
    let annoView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 82))
    var annoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    var annoHotelNameLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 185, height: 20))
    var annoHotelLocationLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 185, height: 12))
    var annoHotelPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 185, height: 12))
    var annoRatingBar = UIView()
    
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)
        
        if(selected)
        {
            
            /*let divideValue = CGFloat(listing.overallRating)/100.00
            let dynamicWidth = annoRatingBar.frame.width * divideValue
            let frame = CGRect(x: annoRatingBar.frame.origin.x, y: annoRatingBar.frame.origin.y, width:dynamicWidth , height: annoRatingBar.frame.height)
            */
            annoHotelNameLabel.font = UIFont(name: "Helvetica", size: 13)
            annoHotelLocationLabel.font = UIFont(name: "Helvetica", size: 10)
            annoHotelPriceLabel.font = UIFont(name: "Helvetica", size: 10)
            
            annoView.center.x = 0.5 * self.frame.size.width;
            annoView.center.y = -0.5 * annoView.frame.height;
            
            annoRatingBar.center.x = 0.5 * annoView.frame.size.width;
            annoRatingBar.center.y = 77
            annoRatingBar.backgroundColor = UIColor(hex: "61C661")
            
            annoImageView.center.x = 40;
            annoImageView.center.y = (0.5 * annoView.frame.height) - 5
            annoImageView.image = #imageLiteral(resourceName: "DelMar")
            
            annoHotelNameLabel.center.x = annoImageView.frame.width + 115
            annoHotelNameLabel.center.y = 15
            annoHotelNameLabel.text = listing.name
            
            annoHotelLocationLabel.center.x = annoImageView.frame.width + 115
            annoHotelLocationLabel.center.y = 35
            annoHotelLocationLabel.text = listing.location
            
            annoHotelPriceLabel.center.x = annoImageView.frame.width + 115
            annoHotelPriceLabel.center.y = 55
            annoHotelPriceLabel.text = listing.price
            
            annoView.layer.cornerRadius = 5
            annoImageView.layer.cornerRadius = 5
            
            annoView.addSubview(annoHotelNameLabel)
            annoView.addSubview(annoHotelLocationLabel)
            annoView.addSubview(annoHotelPriceLabel)
            annoView.addSubview(annoImageView)
            annoView.addSubview(annoRatingBar)
            annoView.backgroundColor = .white
            self.addSubview(annoView)
        }
        else
        {
            annoView.removeFromSuperview()
        }
    }

}
