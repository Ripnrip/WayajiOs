//
//  OfferTableViewCell.swift
//  Wayaj
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Spring
import CoreData


class OfferTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var heartButton: SpringButton!
    @IBOutlet weak var offerImage: UIImageView!
    
    var isSaved = false
    var listingObject:Listing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func saveOffer(_ sender: Any) {
        heartButton.animation = "pop"
        heartButton.animate()
        
        let imageData: NSData = UIImagePNGRepresentation(UIImage(named: "placeA")!)! as NSData

        
        if isSaved == false {
           
            isSaved = true
            heartButton.setImage(UIImage(named: "greenHeart"), for: .normal)
            storeOffer(listingObject: listingObject, name: nameLabel.text!, location: locationLabel.text!, isFavorited: true, image: imageData , price: 199.99)
            
        } else {
            isSaved = false
            heartButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
            storeOffer(listingObject: listingObject, name: nameLabel.text!, location: locationLabel.text!, isFavorited: false, image: imageData , price: 199.99)
        }
    }
    

    
    func storeOffer (listingObject:Listing, name: String, location: String, isFavorited: Bool, image: NSData, price: Double) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Offer",
                                       in: managedContext)!
        
        let offer = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        offer.setValue(name, forKeyPath: "name")
        offer.setValue(isFavorited, forKey: "isFavorited")
        offer.setValue(location, forKey: "location")
        offer.setValue(image, forKey: "image")
        offer.setValue(0.00, forKey: "price")

        
        // 4
        do {
            try managedContext.save()
            //people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
