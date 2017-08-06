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
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        //1
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//        
//     //   let managedContext =
//         //   appDelegate.persistentContainer.viewContext
//        
//        //2
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "Offer")
//        
//        //3
//        do {
//            offers = try managedContext.fetch(fetchRequest)
//            print("the offers saved are \(offers.count)")
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
