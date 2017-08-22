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
    dynamic var id: String = ""
    dynamic var image1:String = ""
    dynamic var image2:String = ""
    dynamic var image3:String = ""
    dynamic var image4:String = ""
    dynamic var name:String = ""
    dynamic var location:String = ""
    dynamic var stars: Int = 0
    dynamic var isFavorited:Bool = false
    dynamic var URL:String = ""
    dynamic var listingDescription:String = ""
    dynamic var completed = false
    
    dynamic var price:String = ""
    dynamic var overallRating:Int = 0
    dynamic var materialAndResourceScore:Int = 0
    dynamic var managementScore:Int = 0
    dynamic var communityScore:Int = 0
    dynamic var waterScore:Int = 0
    dynamic var recycleAndWaterScore:Int = 0
    dynamic var energyScore:Int = 0
    dynamic var indoorsScore:Int = 0

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
