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
    
    @objc dynamic var email = ""
    @objc dynamic var facebook_id = ""
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var info = ""
    @objc dynamic var gender = ""
    @objc dynamic var notifications = false
    @objc dynamic var profile = ""
    
    
    override class func primaryKey() -> String? {
        return "facebook_id"
    }
    
}
