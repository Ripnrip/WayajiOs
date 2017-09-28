//
//  Listing.swift
//  Wayaj
//
//  Created by Admin on 8/18/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import Foundation
import RealmSwift

final class Listing: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var image1:String = ""
    @objc dynamic var image2:String = ""
    @objc dynamic var image3:String = ""
    @objc dynamic var image4:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var location:String = ""
    @objc dynamic var stars: Int = 0
    @objc dynamic var isFavorited:Bool = false
    @objc dynamic var URL:String = ""
    @objc dynamic var listingDescription:String = ""
    @objc dynamic var completed = false
    
    @objc dynamic var price:String = ""
    @objc dynamic var overallRating:Int = 0
    @objc dynamic var materialAndResourceScore:Int = 0
    @objc dynamic var managementScore:Int = 0
    @objc dynamic var communityScore:Int = 0
    @objc dynamic var waterScore:Int = 0
    @objc dynamic var recycleAndWaterScore:Int = 0
    @objc dynamic var energyScore:Int = 0
    @objc dynamic var indoorsScore:Int = 0
    @objc dynamic var longitude:Double = 0.0
    @objc dynamic var latitude:Double = 0.0

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
