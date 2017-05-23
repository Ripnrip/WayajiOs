//
//  ExploreViewController.swift
//  Wayaj
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import paper_onboarding

struct Listing {
    let image:Image
    let name:String
    let location:String
    let stars: Int
    let isFavorited:Bool
}

var Listings = [Listing]()

class ExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var whereButton: UIButton!
    @IBOutlet weak var searchView: UIView!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.upButton.isHidden = true
        self.whereButton.isHidden = true
        loadListings()
    }

    func loadListings() {
        let listing1 = Listing(image: #imageLiteral(resourceName: "innByTheSea"), name: "Inn By The Sea", location: "example", stars: 4, isFavorited: false)
        let listing2 = Listing(image: #imageLiteral(resourceName: "destinationHotel"), name: "Destination Hotel", location: "example", stars: 4, isFavorited: false)
        let listing3 = Listing(image: #imageLiteral(resourceName: "MaunaLani"), name: "Mauna Lani", location: "example", stars: 4, isFavorited: false)
        let listing4 = Listing(image: #imageLiteral(resourceName: "markSpencerHotel"), name: "Mark Spencer HHotel", location: "example", stars: 4, isFavorited: false)
        let listing5 = Listing(image: #imageLiteral(resourceName: "hotelSkylar"), name: "Hotel Skylar", location: "example", stars: 4, isFavorited: false)
        Listings = [listing1,listing2,listing3,listing4,listing5]
    }

    @IBAction func expandSearchFilter(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame = CGRect(x: 19, y: -90, width: 337, height: 47)
            self.tableView.frame = CGRect(x: 0, y: 366, width: self.view.frame.width, height: self.view.frame.size.height)
        }, completion: {
            (value: Bool) in
            //self.blurBg.hidden = true
            self.upButton.isHidden = false
            self.whereButton.isHidden = false
        })
        
    }

    @IBAction func retractSearchFilter(_ sender: Any) {
        //height is 98
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame = CGRect(x: 19, y: 28, width: 337, height: 47)
            self.tableView.frame = CGRect(x: 0, y: 98, width: self.view.frame.width, height: self.view.frame.size.height)
        }, completion: {
            (value: Bool) in
            //self.blurBg.hidden = true
            self.upButton.isHidden = true
            self.whereButton.isHidden = true
        })

    }
    
}

extension ExploreViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!//UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.performSegue(withIdentifier: "viewOffer", sender: nil)
        self.performSegue(withIdentifier: "viewTripAdvisorListing", sender: nil)

        
    }
}

