//
//  User.swift
//  Wayaj
//
//  Created by Admin on 8/18/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    dynamic var email = ""
    dynamic var facebook_id = ""
    dynamic var id = 0
    dynamic var name = ""
    dynamic var photo = ""
    dynamic var info = ""
    dynamic var gender = ""
    
    override class func primaryKey() -> String? {
        return "facebook_id"
    }
    
}
