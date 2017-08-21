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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
