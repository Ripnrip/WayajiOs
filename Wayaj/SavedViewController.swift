//
//  SavedViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/9/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import CoreData

class SavedViewController: UIViewController {
    
    var offers: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Offer")
        
        //3
        do {
            offers = try managedContext.fetch(fetchRequest)
            print("the offers saved are \(offers.count)")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }



}
