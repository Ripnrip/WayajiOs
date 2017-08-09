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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllListings.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferTableViewCell
        cell.listingObject = AllListings.listings[indexPath.section]
        cell.offerImage?.image = AllListings.listings[indexPath.section].image
        cell.nameLabel.text = AllListings.listings[indexPath.section].name
        cell.locationLabel.text = AllListings.listings[indexPath.section].location
        
        return cell//UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    
}
