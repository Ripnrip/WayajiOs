//
//  Offer+CoreDataProperties.swift
//  
//
//  Created by Admin on 8/22/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Offer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double

}
