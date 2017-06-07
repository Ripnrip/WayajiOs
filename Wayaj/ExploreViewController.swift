//
//  ExploreViewController.swift
//  Wayaj
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import paper_onboarding
import AMTooltip
import LocationPickerViewController


struct Listing {
    let image:Image
    let images:[Image]?
    let name:String
    let location:String
    let stars: Int
    let isFavorited:Bool
    let URL:URL?
}

var Listings = [Listing]()
var selectedListing = Listing(image: #imageLiteral(resourceName: "CayoBeach"), images: nil, name: "", location: "", stars: 4, isFavorited: false, URL: nil)

class ExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var whereButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keywordButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.upButton.isHidden = true
        self.whereButton.isHidden = true
        loadListings()
        
        
        //tips
        let shouldShowQuestionaire:Bool = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial3"))
        if shouldShowQuestionaire == false {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                AMTooltipView(message: "Start By Searching for a Destination",
                              focusView: self.searchView, //pass view you want show tooltip over it
                    target: self)
                UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial3")
            }
            
        }else{
            
        }
        

        
        

    }

    func loadListings() {
        let listing1 = Listing(image: #imageLiteral(resourceName: "DelMar"), images: nil, name: "L'Auberge Del Mar", location: "Del Mar, CA", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g32286-d76752-Reviews-L_Auberge_Del_Mar-Del_Mar_California.html"))
        let listing2 = Listing(image: #imageLiteral(resourceName: "Inspira"), images: nil, name: "Inspira Santa Marta Hotel", location: "Portugal", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g189158-d1580631-Reviews-Inspira_Santa_Marta_Hotel-Lisbon_Lisbon_District_Central_Portugal.html"))
        let listing3 = Listing(image: #imageLiteral(resourceName: "MaunaLani"), images: nil, name: "Mauna Lani", location: "Waimea, HI", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g2312116-d111599-Reviews-Mauna_Lani_Bay_Hotel_Bungalows-Puako_Kohala_Coast_Island_of_Hawaii_Hawaii.html"))
        let listing4 = Listing(image: #imageLiteral(resourceName: "markSpencerHotel"), images: nil, name: "Mark Spencer Hotel", location: "Portland, OR", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g52024-d96156-Reviews-Mark_Spencer_Hotel-Portland_Oregon.html"))
        let listing5 = Listing(image: #imageLiteral(resourceName: "hotelSkylar"), images: nil , name: "Hotel Skylar", location: "Fingerlakes, NY", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g48713-d2138174-Reviews-Hotel_Skyler-Syracuse_Finger_Lakes_New_York.html"))
        let listing6 = Listing(image: #imageLiteral(resourceName: "CayoBeach"), images: nil, name: "Cayo Arena Beach Eco Hotel", location: "Dominican Republic", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g4156412-d7335762-Reviews-Cayo_Arena_Beach_EcoHotel-Punta_Rucia_Puerto_Plata_Province_Dominican_Republic.html"))
        let listing7 = Listing(image: #imageLiteral(resourceName: "CasaSol"), images: nil, name: "Casa Sol Bed and Breakfast", location: "Puerto Rico", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g147320-d5964475-Reviews-Casa_Sol_Bed_and_Breakfast-San_Juan_Puerto_Rico.html"))
        let listing8 = Listing(image: #imageLiteral(resourceName: "Rainforest"), images: nil, name: "Rainforest Inn Bed & Breakfast", location: "Puerto Rico", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g147324-d503287-Reviews-Rainforest_Inn-El_Yunque_National_Forest_Puerto_Rico.html"))
        let listing9 = Listing(image: #imageLiteral(resourceName: "innByTheSea"), images: nil, name: "Inn By The Sea", location: "Cape Elizabeth, ME", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g40554-d198688-Reviews-Inn_by_the_Sea-Cape_Elizabeth_Maine.html"))

        Listings = [listing1,listing2,listing3,listing4,listing5,listing6,listing7,listing8,listing9]
    }

    @IBAction func expandSearchFilter(_ sender: Any) {

        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame = CGRect(x: 19, y: -90, width: 337, height: 47)
            self.tableView.frame = CGRect(x: 0, y: 366, width: self.view.frame.width, height: self.view.frame.size.height-44)
        }, completion: {
            (value: Bool) in
            //self.blurBg.hidden = true
            self.upButton.isHidden = false
            self.whereButton.isHidden = false
        })
        
        
        //first time user
        //tips
        let shouldShowQuestionaire:Bool = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial4"))
        if shouldShowQuestionaire == false {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                AMTooltipView(message: "Search by any criteria, or any keywords",
                              focusFrame: CGRect(x:20, y:50, width:self.keywordButton.frame.width, height:270),
                              target: self.tabBarController)
                UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial4")
            }
        }else{
            
        }

        

        
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
    
    @IBAction func whereSearch(_ sender: Any) {
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
        }


        locationPicker.addBarButtons()
        let navBar = UINavigationController(rootViewController: locationPicker)
        //self.navigationController?.pushViewController(locationPicker, animated: true)
        self.present(navBar, animated: true, completion: nil)
    }
    
    @IBAction func whenSearch(_ sender: Any) {
        
    }
    
    @IBAction func howManySearch(_ sender: Any) {
        
    }
    
    @IBAction func keywordSearch(_ sender: Any) {
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewOffer" {
            if let controller = segue.destination as? OfferPageViewController {
                controller.currentListing = selectedListing
            }
        }
    }
}

extension ExploreViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return Listings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferTableViewCell
        cell.offerImage?.image = Listings[indexPath.section].image
        cell.nameLabel.text = Listings[indexPath.section].name
        cell.locationLabel.text = Listings[indexPath.section].location
        
        return cell//UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = Listings[indexPath.section]
        //self.performSegue(withIdentifier: "viewOffer", sender: nil)
        //self.performSegue(withIdentifier: "viewTripAdvisorListing", sender: nil)
        let myVC = storyboard?.instantiateViewController(withIdentifier: "offerPageDetail") as! OfferPageViewController
        myVC.currentListing = selectedListing
        myVC.bookURL = selectedListing.URL!
        myVC.image = selectedListing.image
        self.navigationController?.pushViewController(myVC, animated: true)

        
    }
}

