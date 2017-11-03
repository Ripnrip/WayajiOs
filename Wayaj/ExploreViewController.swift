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
import SwiftSpinner
import AudioToolbox
import AVFoundation
import Cheers
import RealmSwift
import Realm
import Kingfisher
import CoreData
import CoreLocation
import AddressBookUI
import MapKit
import RangeSeekSlider


struct AllListings {
    static var listings = [Listing]()
}




var Listings = [Listing]()
var locationsArray = [String]()
var savedListings = [Listing]()

var annotations = [MKPointAnnotation]()
//var annos = [MKPointAnnotation, Listing]


var annoSelectedListing = Listing()

var selectedListing = Listing()
var searchActive : Bool = false




class ExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, RangeSeekSliderDelegate {
    
    
    //let googleBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    //let googleApikey = "AIzaSyCvaFusdMkQsS7VRZCIWbmkOFI7xP4qAQA"
    
    var locationManager2:CLLocationManager!
    @IBOutlet weak var whereSearchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var whereButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keywordButton: UIButton!
    @IBOutlet weak var whenButton: UIButton!
    @IBOutlet weak var howManyButton: UIButton!
    
    @IBOutlet weak var filterButton: UIButton!
    
    
    @IBOutlet weak var mapButton: UIButton!
    var listingState = "List"
    
    
    @IBOutlet weak var listingsMapView: MKMapView!
    
    var isFiltering = false
    var greyView: UIView!
    var priceSlider:RangeSeekSlider!
    var ratingSlider:RangeSeekSlider!
    
    var ratingOneLabel: UILabel!
    var ratingTwoLabel: UILabel!
    var ratingThreeLabel: UILabel!
    var ratingFourLabel: UILabel!
    
    var pvY: CGFloat!
    
    var filterPriceOptions = [String]()
    var filterRatingOption = ""
    
    
    var divideValue:CGFloat!
    
    var filteredPrices =  ["$"]
    var filteredRatings = [Int]()
    
    var AFRICA = Continent(name: "AFRICA", countries: ["Algeria", "Angola", "Benin", "Botswana", "Burkina", "Burundi", "Cameroon", "Cape Verde", "Central African Republic", "Chad", "Comoros", "Congo", "Congo", "Democratic Republic of", "Djibouti", "Egypt", "Equatorial Guinea", "Eritrea", "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Ivory Coast", "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone", "Somalia", "South Africa", "South Sudan", "Sudan", "Swaziland", "Tanzania", "Togo", "Tunisia", "Uganda", "Zambia", "Zimbabwe"])
    let ASIA = Continent(name: "ASIA",countries: ["Afghanistan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Burma (Myanmar)", "Cambodia", "China", "East Timor", "India", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Korea", "North", "Korea", "South", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Malaysia", "Maldives", "Mongolia", "Nepal", "Oman", "Pakistan", "Philippines", "Qatar", "Russian Federation", "Saudi Arabia", "Singapore", "Sri Lanka", "Syria", "Tajikistan", "Thailand", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam", "Yemen"])
    let EUROPE = Continent(name: "EUROPE",countries: ["Albania", "Andorra", "Armenia", "Austria", "Azerbaijan", "Belarus", "Belgium", "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Malta", "Moldova", "Monaco", "Montenegro", "Netherlands", "Norway", "Poland", "Portugal", "Romania", "San Marino", "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Ukraine", "United Kingdom", "Vatican City"])
    let NORTH_AMERICA = Continent(name: "North america",countries: ["Antigua and Barbuda", "Bahamas", "Barbados", "Belize", "Canada", "Costa Rica", "Cuba", "Dominica", "Dominican Republic", "El Salvador", "Grenada", "Guatemala", "Haiti", "Honduras", "Jamaica", "Mexico", "Nicaragua", "Panama", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Trinidad and Tobago", "United States"])
    let SOUTH_AMERICA = Continent(name: "South america",countries: ["Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "Guyana", "Paraguay", "Peru", "Suriname", "Uruguay", "Venezuela"])
    let OCEANIA = Continent(name: "oceania",countries: ["Australia", "Fiji", "Kiribati", "Marshall Islands", "Micronesia", "Nauru", "New Zealand", "Palau", "Polynesia", "French Polynesia", "Papua New Guinea", "Samoa", "Solomon Islands", "Tonga", "Tuvalu", "Vanuatu"])






    
    
    
    var player: AVAudioPlayer?
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController.dismissKeyboard))
    
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[Listing] = []
    
    var items = List<Listing>()
    var itemResults = [Listing]()
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            //shakeLabel.text = "Shaken, not stirred"
            print("shaken, not stirred")
            
            //playSound()
            
            // Create the view
            let cheerView = CheerView()
            view.addSubview(cheerView)
            
            // Configure
            cheerView.config.particle = .confetti
            
            // Start
            cheerView.start()
            
            // Stop
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                cheerView.stop()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        SwiftSpinner.hide()
        
        shouldShowQuestionare()
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        setupFilters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager2 = CLLocationManager()
        
        // Do any additional setup after loading the view.
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        whereSearchBar.delegate = self
        let textFieldInsideSearchBar = whereSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        if let textFieldInsideSearchBar = whereSearchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
        
        self.upButton.isHidden = true
        //loadListings()
        self.loadMapSettings()
        listingsMapView.showsUserLocation = false
        whereSearchBar.setImage(UIImage(named: "SearchBarImage"), for: UISearchBarIcon.search, state: .normal)
        //whereSearchBar.backgroundColor = UIColor(hex: "50D172")
        
        for view in whereSearchBar.subviews {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    textField.backgroundColor = UIColor(hex: "50D172")
                }
            }
        }
        
        //datePicker.frame = whenButton.frame
        //occupantFilter.frame = howManyButton.frame
        //view.addSubview(datePicker)
        //view.addSubview(occupantFilter)
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
        self.setupRealm()
        //writeToRealm()
        
    }
    
    func shouldShowQuestionare(){
        let shouldNotShowQuestionaire:Bool = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial2"))
        if let name:String = (UserDefaults.standard.value(forKey: "name") as? String) {
            if shouldNotShowQuestionaire == false && name.length > 1 {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let editPro = storyBoard.instantiateViewController(withIdentifier: "editProfile") as! EditProfileViewController
                DispatchQueue.main.async {
                    self.navigationController?.present(editPro, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(editPro, animated: true)
                    //self.present(editPro, animated: true, completion: nil)
                    //self.navigationController?.tabBarController?.tabBar.isHidden = true
                    
                }
                
            }else{
                //self.performSegue(withIdentifier: "goHome", sender: self)
            }
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadMapSettings(){
        self.locationManager2.delegate = self
        self.locationManager2.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager2.requestWhenInUseAuthorization()
        self.locationManager2.startUpdatingLocation()
        self.listingsMapView.showsUserLocation = true
        //self.listingsMapView.delegate = self
    }
    
    func addAnnotations() {
        
        print("IM IN HERE")
        
        print(itemResults.count)
        
        annotations.removeAll()
        
        let existingAnnotations = listingsMapView.annotations
        listingsMapView.removeAnnotations(existingAnnotations)
        
        itemResults.forEach { (listing) in
            
            let lat = listing.latitude, long = listing.longitude
            
            let location = CLLocation(latitude: lat, longitude: long)
            
            let anno = CustomMapPinAnnotation()
            anno.coordinate = location.coordinate
            anno.title = listing.name
            anno.subtitle = listing.location
            anno.listingObject = listing
            //listingsMapView.addAnnotation(anno)
            print("this hotel is \(listing.name)")
            
            //TODO - custom anno with listing object then open listing when anno is tapped
            annotations.append(anno)
        }
        
        annotations.forEach { (anno) in
            listingsMapView.addAnnotation(anno)
            print(anno)
        }
        
        listingsMapView.showAnnotations(listingsMapView.annotations, animated: true)
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("checking")
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
        
        self.listingsMapView.setRegion(region, animated: true)
        //Random comment
        locationManager2.stopUpdatingLocation()
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        
        
        /*if let annotation = view.annotation {
         print("Your annotation title: \(String(describing: annotation.title))");
         }
         */
        
        
        if let annoView = view as? CustomWayajAnnotationView {
            if let anno = view.annotation as? CustomMapPinAnnotation {
                
                
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
                tapGesture.delegate = self
                annoSelectedListing = anno.listingObject
                annoView.addGestureRecognizer(tapGesture)
                
                //annoView.annoView.addGestureRecognizer(tapGesture)
                let annoListing = anno.listingObject
                annoView.addSubview(annoView)
                annoView.annoHotelNameLabel.text = annoListing.name
                annoView.annoHotelLocationLabel.text = annoListing.location
                annoView.annoHotelPriceLabel.text = annoListing.price
                annoView.annoImageView.kf.setImage(with: URL(string: annoListing.image1))
                let divideValue = CGFloat(annoListing.overallRating)/100.00
                let dynamicWidth = 280 * divideValue
                let frame = CGRect(x: 0, y: 75, width:dynamicWidth , height: 7)
                annoView.annoRatingBar.frame = frame
            }
        }
        
    }
    
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        
        var myVC = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        
        myVC.imageURL = annoSelectedListing.image1
        myVC.name = annoSelectedListing.name
        myVC.location = annoSelectedListing.location
        myVC.information = annoSelectedListing.listingDescription
        myVC.isFavorited = false
        myVC.price = annoSelectedListing.price
        myVC.currentListing = annoSelectedListing
        
        let divideValue = CGFloat(annoSelectedListing.overallRating)/100.00
        let dynamicWidth = myVC.scoreBar.frame.width * divideValue
        let frame = CGRect(x: myVC.scoreBar.frame.origin.x, y: myVC.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC.scoreBar.frame.height)
        //print("the green bar dynamic width is \(dynamicWidth)")
        //print("the score fraction to divide/multiply by is \(divideValue)")
        myVC.scoreBar.frame = frame
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? CustomMapPinAnnotation {
            
            let selectedListing2 = anno.listingObject
            
            var myVC = storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            
            myVC.imageURL = selectedListing2.image1
            myVC.name = selectedListing2.name
            myVC.location = selectedListing2.location
            myVC.information = selectedListing2.listingDescription
            myVC.isFavorited = false
            myVC.price = selectedListing2.price
            myVC.currentListing = selectedListing2
            myVC.scoreVal = CGFloat(selectedListing2.overallRating)

            
            var mutableString = NSMutableAttributedString(string: "Eco-Rating")
            mutableString.addAttribute(NSAttributedStringKey.font,
                                       value: UIFont.boldSystemFont(ofSize: 12),
                                       range: NSRange(location:0, length: mutableString.length)
            )
            
            if selectedListing2.overallRating > 90 {
                var combo = NSMutableAttributedString()
                combo.append(mutableString)
                combo.append(NSMutableAttributedString(string: ": OUTSTANDING"))
                myVC.ecoRatingScoreLabel.text = "Eco-Rating: OUTSTANDING"
                //cell.scoreLabel.attributedText = combo
            }
            else if selectedListing2.overallRating >= 76 {
                var combo = NSMutableAttributedString()
                combo.append(mutableString)
                combo.append(NSMutableAttributedString(string: ": EXCELLENT"))
                
                myVC.ecoRatingScoreLabel.text = "Eco-Rating: EXCELLENT"
            }   else if selectedListing2.overallRating >= 61 {
                var combo = NSMutableAttributedString()
                combo.append(mutableString)
                combo.append(NSMutableAttributedString(string: ": GREAT"))
                
                myVC.ecoRatingScoreLabel.text = "Eco-Rating: GREAT"
                //cell.scoreLabel.attributedText = combo
            }   else  {
                var combo = NSMutableAttributedString()
                combo.append(mutableString)
                combo.append(NSMutableAttributedString(string: ": GOOD"))
                
                myVC.ecoRatingScoreLabel.text = "Eco-Rating: GOOD"
                //cell.scoreLabel.attributedText = combo
            }
            
            
            let divideValue = CGFloat(selectedListing2.overallRating)/100.00
            let dynamicWidth = myVC.scoreBar.frame.width * divideValue
            let frame = CGRect(x: myVC.scoreBar.frame.origin.x, y: myVC.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC.scoreBar.frame.height)
            //print("the green bar dynamic width is \(dynamicWidth)")
            //print("the score fraction to divide/multiply by is \(divideValue)")
            myVC.scoreBar.frame = frame
            
            self.navigationController?.pushViewController(myVC, animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            
            
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Pin")
        annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        annotationView?.contentMode = UIViewContentMode.scaleAspectFit
        //annotationView?.addGestureRecognizer(tap)
        
        return annotationView
    }
    
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        
        
        //self.locationManager2.startUpdatingLocation()
        //self.loadMapSettings()
        if listingState == "List" {
            //mapButton.setTitle("List", for: .normal)
            mapButton.setImage(UIImage(named: "ListButton"), for: .normal)
            listingsMapView.isHidden = false
            tableView.isHidden = true
            listingState = "Map"
            
        } else if listingState == "Map" {
            //mapButton.setTitle("Map", for: .normal)
            mapButton.setImage(UIImage(named: "MapButton"), for: .normal)
            listingsMapView.isHidden = true
            tableView.isHidden = false
            listingState = "List"
        }
        
        filterButton.setImage(UIImage(named: "enableFilter"), for: .normal)
        isFiltering = false
        greyView.isHidden = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    //MARK: - Custom Annotation
    
    
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "china", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadListings() {
        
        for i in 41...80 {
            let listing1 = Listing()
            listing1.id = String(i)
            listing1.name = ""
            listing1.location = ""
            listing1.image1 = ""
            listing1.image2 = ""
            listing1.image3 = ""
            listing1.image4 = ""
            listing1.listingDescription = ""
            listing1.completed = false
            listing1.stars = 4
            listing1.isFavorited = false
            listing1.URL = ""
            Listings.append(listing1)
        }
        
        AllListings.listings = Listings
        tableView.reloadData()
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
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
            self.whereSearchBar.isHidden = false
            
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
        dismissKeyboard()
        //self.whereSearchBar.isHidden = true
        
        /* UIView.animate(withDuration: 0.2, animations: {
         self.searchView.frame = CGRect(x: 19, y: 28, width: 337, height: 47)
         self.tableView.frame = CGRect(x: 0, y: 98, width: self.view.frame.width, height: self.view.frame.size.height)
         }, completion: {
         (value: Bool) in
         //self.blurBg.hidden = true
         self.upButton.isHidden = true
         //self.whereButton.isHidden = true
         
         
         })*/
        
    }
    
    @IBAction func whereSearch(_ sender: Any) {
        /*UIView.animate(withDuration: 0.2) {
         self.whereSearchBar.frame = CGRect(x: self.whereButton.frame.origin.x + 100, y: self.whereButton.center.y - 22  , width: 180, height: 44)
         
         }*/
        
        
    }
    
    @IBAction func whenSearch(_ sender: Any) {
        
    }
    
    @IBAction func howManySearch(_ sender: Any) {
        
    }
    
    @IBAction func keywordSearch(_ sender: Any) {
        
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        
        isFiltering = !isFiltering
        
        if isFiltering {
            // set image
            
            filterButton.setImage(UIImage(named: "disableFilter"), for: .normal)
            showFilters()
            dismissKeyboard()
            mapButton.isEnabled = false
            
            
        } else {
            // set image
            filterButton.setImage(UIImage(named: "enableFilter"), for: .normal)
            greyView.isHidden = true
            mapButton.isEnabled = true
        }
        
        
    }
    
    func setupFilters(){
        
        greyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        greyView.center = tableView.center
        greyView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.addSubview(greyView)
        greyView.isHidden = true
        
        let priceSliderLabel = UILabel(frame: CGRect(x: 14, y: greyView.bounds.origin.y + 14, width: 50, height: 20))
        priceSliderLabel.text = "Price"
        priceSliderLabel.font = UIFont(name: "Helvetica", size: 15)
        priceSliderLabel.textColor = UIColor(hex: "3D444E")
        priceSliderLabel.layer.opacity = 0.6
        
        
        
        
        
        
        
        let priceView = UIView(frame: CGRect(x: greyView.bounds.origin.x, y: greyView.bounds.origin.y, width: greyView.frame.width, height: 108))
        pvY = priceView.bounds.origin.y
        priceView.backgroundColor = .white
        let ratingView = UIView(frame: CGRect(x: greyView.bounds.origin.x, y: greyView.bounds.origin.y + priceView.frame.height, width: greyView.frame.width, height: 128))
        ratingView.backgroundColor = .white
        
        
        
        let filterSearchButton = UIButton(frame: CGRect(x: greyView.bounds.origin.x, y: greyView.bounds.origin.y + priceView.frame.height + ratingView.frame.height, width: greyView.frame.width, height: 46))
        filterSearchButton.backgroundColor = UIColor(hex: "4BBE4B")
        filterSearchButton.setTitle("Search", for: .normal)
        filterSearchButton.titleLabel?.textColor = .white
        filterSearchButton.addTarget(self, action: #selector(filterSearch), for: .touchUpInside)
        
        
        priceSlider = RangeSeekSlider(frame: CGRect(x: 14, y: priceView.bounds.origin.y + 50, width: priceView.frame.width - 28, height: 19))
        priceSlider.isUserInteractionEnabled = true
        priceSlider.minValue = 1
        priceSlider.maxValue = 4
        //priceSlider.stepValue = 1
        priceSlider.hideLabels = true
        priceSlider.handleDiameter = 30
        priceSlider.handleColor = .white
        priceSlider.colorBetweenHandles = UIColor(hex: "4BBE4B")
        priceSlider.tintColor = .gray
        priceSlider.lineHeight = 8
        priceSlider.enableStep = true
        priceSlider.step = 1
        
        ratingSlider = RangeSeekSlider(frame: CGRect(x: 14, y: priceView.bounds.height + 50, width: priceView.frame.width - 28, height: 19))
        ratingSlider.delegate = self
        ratingSlider.isUserInteractionEnabled = true
        ratingSlider.maxValue = 3
        ratingSlider.selectedMaxValue = 0
        //priceSlider.stepValue = 1
        ratingSlider.hideLabels = true
        ratingSlider.handleDiameter = 30
        ratingSlider.handleColor = .white
        ratingSlider.colorBetweenHandles = UIColor(hex: "4BBE4B")
        ratingSlider.tintColor = .gray
        ratingSlider.lineHeight = 8
        ratingSlider.enableStep = true
        ratingSlider.step = 1
        ratingSlider.disableRange = true
        
        divideValue = priceSlider.frame.width / 3
        
        
        
        let priceOneLabel = UILabel(frame: CGRect(x: 28, y: greyView.bounds.origin.y + 80, width: 20, height: 30))
        priceOneLabel.text = "$"
        priceOneLabel.font = UIFont(name: "Helvetica", size: 15)
        priceOneLabel.textColor = UIColor(hex: "3D444E")
        priceOneLabel.layer.opacity = 0.6
        priceOneLabel.sizeToFit()
        let priceTwoLabel = UILabel(frame: CGRect(x: 28 + divideValue, y: greyView.bounds.origin.y + 80, width: 30, height: 30))
        priceTwoLabel.text = "$$"
        priceTwoLabel.font = UIFont(name: "Helvetica", size: 15)
        priceTwoLabel.textColor = UIColor(hex: "3D444E")
        priceTwoLabel.layer.opacity = 0.6
        priceTwoLabel.textAlignment = .center
        priceTwoLabel.sizeToFit()
        priceTwoLabel.frame.origin.x = priceTwoLabel.frame.origin.x - priceTwoLabel.bounds.width
        
        
        let priceThreeLabel = UILabel(frame: CGRect(x: (divideValue * 2), y: greyView.bounds.origin.y + 80, width: 30, height: 30))
        priceThreeLabel.text = "$$$"
        priceThreeLabel.font = UIFont(name: "Helvetica", size: 15)
        priceThreeLabel.textColor = UIColor(hex: "3D444E")
        priceThreeLabel.layer.opacity = 0.6
        priceThreeLabel.textAlignment = .center
        priceThreeLabel.sizeToFit()
        priceThreeLabel.frame.origin.x = (priceSlider.frame.width - divideValue) - (28-priceThreeLabel.frame.width)
        
        let priceFourLabel = UILabel(frame: CGRect(x: (divideValue * 3), y: greyView.bounds.origin.y + 80, width: 30, height: 30))
        priceFourLabel.text = "$$$$"
        priceFourLabel.font = UIFont(name: "Helvetica", size: 15)
        priceFourLabel.textColor = UIColor(hex: "3D444E")
        priceFourLabel.layer.opacity = 0.6
        priceFourLabel.sizeToFit()
        priceFourLabel.frame.origin.x = (divideValue*3) - priceFourLabel.frame.width
        
        ratingOneLabel = UILabel(frame: CGRect(x: 28, y: ratingView.bounds.origin.y + 80, width: 50, height: 30))
        ratingOneLabel.layer.cornerRadius = 5
        ratingOneLabel.text = "GOOD"
        ratingOneLabel.font = UIFont(name: "Helvetica", size: 11)
        ratingOneLabel.textColor = .white
        ratingOneLabel.textAlignment = .center
        ratingOneLabel.backgroundColor = UIColor(hex: "4BBE4B")
        ratingOneLabel.clipsToBounds = true
        
        //ratingOneLabel.sizeToFit()
        ratingTwoLabel = UILabel(frame: CGRect(x: 28 + divideValue, y: ratingView.bounds.origin.y + 80, width: 30, height: 30))
        ratingTwoLabel.text = "GREAT"
        ratingTwoLabel.font = UIFont(name: "Helvetica", size: 11)
        ratingTwoLabel.textColor = .white
        ratingTwoLabel.textAlignment = .center
        ratingTwoLabel.backgroundColor = UIColor(hex: "4BBE4B")
        //ratingTwoLabel.sizeToFit()
        ratingTwoLabel.frame.origin.x = ratingTwoLabel.frame.origin.x - ratingTwoLabel.bounds.width
        
        
        ratingThreeLabel = UILabel(frame: CGRect(x: (divideValue * 2), y: ratingView.bounds.origin.y + 80, width: 30, height: 30))
        ratingThreeLabel.text = "EXCELLENT"
        ratingThreeLabel.font = UIFont(name: "Helvetica", size: 11)
        ratingThreeLabel.textColor = .white
        ratingThreeLabel.textAlignment = .center
        ratingThreeLabel.backgroundColor = UIColor(hex: "4BBE4B")
        //ratingThreeLabel.sizeToFit()
        ratingThreeLabel.frame.origin.x = (ratingSlider.frame.width - divideValue) - (28-ratingThreeLabel.frame.width)
        
        ratingFourLabel = UILabel(frame: CGRect(x: (divideValue * 3), y: ratingView.bounds.origin.y + 80, width: 30, height: 30))
        ratingFourLabel.text = "OUTSTANDING"
        ratingFourLabel.font = UIFont(name: "Helvetica", size: 11)
        ratingFourLabel.textColor = .white
        ratingFourLabel.backgroundColor = UIColor(hex: "4BBE4B")
        //ratingFourLabel.sizeToFit()
        ratingFourLabel.frame.origin.x = (divideValue*3) - ratingFourLabel.frame.width
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: priceView.frame.size.height - 1.0, width: priceView.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor(hex: "D9E8FC").cgColor
        priceView.layer.addSublayer(bottomBorder)
        
        
        let ratingSliderLabel = UILabel(frame: CGRect(x: 14, y: ratingView.bounds.origin.y + 14, width: 50, height: 20))
        ratingSliderLabel.text = "Eco-Rating"
        ratingSliderLabel.font = UIFont(name: "Helvetica", size: 15)
        ratingSliderLabel.textColor = UIColor(hex: "3D444E")
        ratingSliderLabel.layer.opacity = 0.6
        
        priceView.addSubview(priceSliderLabel)
        priceView.addSubview(priceOneLabel)
        priceView.addSubview(priceTwoLabel)
        priceView.addSubview(priceThreeLabel)
        priceView.addSubview(priceFourLabel)
        ratingView.addSubview(ratingOneLabel)
        
        greyView.addSubview(ratingSliderLabel)
        greyView.addSubview(priceView)
        greyView.addSubview(ratingView)
        greyView.addSubview(filterSearchButton)
        greyView.addSubview(priceSlider)
        greyView.addSubview(ratingSlider)
        greyView.isUserInteractionEnabled = true
        //greyView.addSubview(ratingSlider)
        
        
        
        
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("hello\(maxValue)")
        
        print("hiiii")
        switch maxValue{
            
        case 0.0:
            ratingOneLabel.text = "GOOD"
            ratingOneLabel.sizeToFit()
            ratingOneLabel.frame = CGRect(x: ratingOneLabel.bounds.origin.x, y: pvY + 80, width: ratingOneLabel.frame.width + 20, height: ratingOneLabel.frame.height + 20)
            ratingOneLabel.layer.cornerRadius = 5
            ratingOneLabel.frame.origin.x = 28
            ratingOneLabel.clipsToBounds = true
            
            
        case 1.0:
            ratingOneLabel.text = "GREAT"
            ratingOneLabel.sizeToFit()
            ratingOneLabel.frame = CGRect(x: ratingOneLabel.bounds.origin.x, y: pvY + 80, width: ratingOneLabel.frame.width + 20, height: ratingOneLabel.frame.height + 20)
            ratingOneLabel.layer.cornerRadius = 5
            ratingOneLabel.frame.origin.x = (28 + divideValue) - (ratingOneLabel.frame.width/2) - 10
            //ratingOneLabel.clipsToBounds = true
            print("WELL HELLO")
            
        case 2.0:
            ratingOneLabel.text = "EXCELLENT"
            ratingOneLabel.sizeToFit()
            ratingOneLabel.frame = CGRect(x: ratingOneLabel.bounds.origin.x, y: pvY + 80, width: ratingOneLabel.frame.width + 20, height: ratingOneLabel.frame.height + 20)
            ratingOneLabel.layer.cornerRadius = 5
            ratingOneLabel.frame.origin.x = (ratingSlider.frame.width - divideValue) - (ratingOneLabel.frame.width / 2.0)
            ratingOneLabel.clipsToBounds = true
            
            
        case 3.0:
            
            ratingOneLabel.text = "OUTSTANDING"
            ratingOneLabel.sizeToFit()
            ratingOneLabel.frame = CGRect(x: ratingOneLabel.bounds.origin.x, y: pvY + 80, width: ratingOneLabel.frame.width + 20, height: ratingOneLabel.frame.height + 20)
            ratingOneLabel.layer.cornerRadius = 5
            ratingOneLabel.frame.origin.x = (divideValue*3) - ratingOneLabel.frame.width
            ratingOneLabel.clipsToBounds = true
            
            
            
        default:
            ratingOneLabel.text = "GOOD"
            ratingOneLabel.sizeToFit()
            ratingOneLabel.frame = CGRect(x: ratingOneLabel.bounds.origin.x, y: pvY + 80, width: ratingOneLabel.frame.width + 20, height: ratingOneLabel.frame.height + 20)
            ratingOneLabel.layer.cornerRadius = 5
            ratingOneLabel.frame.origin.x = 28
            ratingOneLabel.clipsToBounds = true
            
        }
        
        
    }
    
    @objc func filterSearch(sender: UIButton!) {
        print("Button tapped")
        mapButton.isEnabled = true
        var geocoder = CLGeocoder()

        self.itemResults = Listings
        //isFiltering = false
        dismissKeyboard()
        filterPriceOptions.removeAll()
        filterRatingOption = ""
        
        let minPrice = priceSlider.selectedMinValue
        let maxPrice = priceSlider.selectedMaxValue
        let rating = ratingSlider.selectedMaxValue
        
        switch minPrice {
            
        case 1:
            filterPriceOptions.append("$")
        case 2:
            filterPriceOptions.append("$$")
        case 3:
            filterPriceOptions.append("$$$")
        case 4:
            filterPriceOptions.append("$$$$")
        default: break
            
        }
        
        switch maxPrice {
            
        case 1:
            filterPriceOptions.append("$")
        case 2:
            if minPrice == 1 { filterPriceOptions.append("$")}
            filterPriceOptions.append("$$")
        case 3:
            if minPrice == 1 {
                filterPriceOptions.append("$")
                filterPriceOptions.append("$$")
            }
            if minPrice == 2 {
                filterPriceOptions.append("$$")
            }
            
            filterPriceOptions.append("$$$")
        case 4:
            if minPrice == 1 {
                filterPriceOptions.append("$")
                filterPriceOptions.append("$$")
                filterPriceOptions.append("$$$")
                
            }
            if minPrice == 2 {
                filterPriceOptions.append("$$")
                filterPriceOptions.append("$$$")
            }
            if minPrice == 3 {
                filterPriceOptions.append("$$$")
            }
            filterPriceOptions.append("$$$$")
        default: break
            
        }
        
        switch rating {
            
        case 0:
            filterRatingOption = "GOOD"
        case 1:
            filterRatingOption = "GREAT"
        case 2:
            filterRatingOption = "EXCELLENT"
        case 3:
            filterRatingOption = "OUTSTANDING"
        default:
            filterRatingOption = "GOOD"
        }
        
        
        SwiftSpinner.show("Searching")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("Are we there yet?")
            SwiftSpinner.hide()
            
            self.filtered = self.itemResults.filter({ (item) -> Bool in
                let location: NSString = item.location as NSString
                let ratingNew = self.getRating(rating: item.overallRating)
                
                let searchText = self.whereSearchBar.text
                
                if searchText != "" {
                    
                    var isInContinent = false
                    var continents = [self.AFRICA,self.ASIA,self.EUROPE,self.NORTH_AMERICA,self.SOUTH_AMERICA,self.OCEANIA]
                    
                    for continent in continents {
                        
                        for country in continent.countries {
                            if (continent.name.lowercased().range(of: searchText!.lowercased()) != nil &&
                                item.location.lowercased().range(of: country.lowercased()) != nil){
                            
                                isInContinent = true
                                print("continent found")
                                
                            }
                            
                        
                        }
                    
                    }
                    
                    if (isInContinent && self.filterPriceOptions.contains(item.price) && self.filterRatingOption.contains(ratingNew)) {
                        print("HERE 1")
                        return true
                    }
                    
                    
                    if (item.location.lowercased().range(of:searchText!.lowercased()) != nil && self.filterPriceOptions.contains(item.price) && self.filterRatingOption.contains(ratingNew)) {
                        print("HERE 2")

                        return true
                    }
                    
                    let range = location.range(of: searchText!, options: .caseInsensitive)
                    if (range.location != NSNotFound && self.filterPriceOptions.contains(item.price) && self.filterRatingOption.contains(ratingNew)) {
                        print("HERE 3")

                        return true
                    } else {
                        
                        return false
                    }
                    
                    
                } else {
                    if (self.filterPriceOptions.contains(item.price) && self.filterRatingOption.contains(ratingNew)) {
                        return true
                        print("HERE 4")

                    } else {
                        return false
                    }
                    
                    
                }
                
                return false
                //return range.location != NSNotFound
            })
            if(self.filtered.count == 0){
                searchActive = false;
                //no results
                print("No results")
                let alertController = UIAlertController(title: "No luck", message: "Check back later", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                    self.itemResults = Listings
                }
                
                self.isFiltering = true
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                self.filterButton.imageView?.image = UIImage(named: "enableFilter")
                searchActive = true
                print("results \(self.filtered)")
                self.itemResults.removeAll()
                self.itemResults = self.filtered
                self.whereSearchBar.resignFirstResponder()
                self.addAnnotations()
                self.greyView.isHidden = true
                self.isFiltering = false
                self.filterButton.setImage(UIImage(named: "enableFilter"), for: .normal)
                self.tableView.reloadData()
                self.listingsMapView.showAnnotations(self.listingsMapView.annotations, animated: true)
                
            }
        }
        
        
        
        
    }
    
    func showFilters() {
        
        filterButton.imageView?.image = UIImage(named: "disableFilter")
        greyView.isHidden = false
        
        
    }
    
    
    
    //MARK: Realm
    func setupRealm() {
        // Log in existing user with username and password
        let username = "zenun@isokanco.com"  // <--- Update this
        let password
            = "GedeonGRC1"  // <--- Update this
        
        var fetchedItems =
            
            
            SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://ec2-54-236-13-40.compute-1.amazonaws.com:9080")!) { user, error in
                guard let user = user else {
                    fatalError(String(describing: error))
                }
                
                DispatchQueue.main.async {
                    // Open Realm
                    let configuration = Realm.Configuration(
                        syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://ec2-54-236-13-40.compute-1.amazonaws.com:9080/551c0c624123f0796cb8eadd3167c59c/Realm/Wayaj-Listings")!)
                    )
                    self.realm = try! Realm(configuration: configuration)
                    
                    
                    //print("all the LISTING objects are \(self.realm.objects(Listing.self))")
                    // Show initial tasks
                    func updateList() {
                        let results = self.realm.objects(Listing.self)
                        //print(results[0])
                        let converted = results.reduce(List<Listing>()) { (list, element) -> List<Listing> in
                            if element.completed == true {
                                list.append(element)
                            }
                            return list
                        }
                        
                        for result in results {
                            
                            
                            let temp = Listing()
                            temp.id = result.id
                            temp.image1 = result.image1
                            temp.image2 = result.image2
                            temp.image3 = result.image3
                            temp.image4 = result.image4
                            temp.name = result.name
                            temp.location = result.location
                            temp.stars = result.stars
                            temp.isFavorited = result.isFavorited
                            temp.URL = result.URL
                            temp.listingDescription = result.listingDescription
                            temp.completed = result.completed
                            temp.price = result.price
                            temp.overallRating = result.overallRating
                            temp.materialAndResourceScore = result.materialAndResourceScore
                            temp.managementScore = result.managementScore
                            temp.communityScore = result.communityScore
                            temp.waterScore = result.waterScore
                            temp.recycleAndWaterScore = result.recycleAndWaterScore
                            temp.energyScore = result.energyScore
                            temp.indoorsScore = result.indoorsScore
                            temp.longitude = result.longitude
                            temp.latitude = result.latitude
                            
                            if temp.overallRating != 0 {
                                Listings.append(temp)
                                self.itemResults.append(temp)
                                print(temp)
                            }
                            
                            
                        }
                        
                        if self.items.realm == nil  {
                            self.items = converted
                        }
                        //Listings = Array(converted)
                        //print(converted)
                        //self.itemResults = Array(converted)
                        //self.itemResults.shuffle()
                        self.addAnnotations()
                        self.tableView.reloadData()
                    }
                    updateList()
                    
                    // Notify us when Realm changes
                    self.notificationToken = self.realm.addNotificationBlock { _,_  in
                        updateList()
                    }
                    
                }
                
        }
    }
    
    
    
    func add() {
        
        
        //self.items.append(Task(value: ["text": text]))
        let items = Listings
        
        // let sampleListing = Listing()
        try! self.realm.write {
            //self.realm.add(Task(value: ["text": text]))
            self.realm.add(items)
            self.tableView.reloadData()
            
        }
        
    }
    
    
    deinit {
        notificationToken.stop()
    }
    
    //MARK: Storyboard exit
    
    
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
        return itemResults.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferTableViewCell
        cell.listingObject = itemResults[indexPath.row]
        let imageURL = URL(string:itemResults[indexPath.row].image1)
        cell.offerImage.kf.setImage(with: imageURL)
        cell.nameLabel.text = itemResults[indexPath.row].name
        cell.locationLabel.text = itemResults[indexPath.row].location
        cell.id = itemResults[indexPath.row].id
        cell.priceLabel.text = itemResults[indexPath.row].price
        
        if savedListings.contains(itemResults[indexPath.row]) {
            cell.heartButton.setImage(#imageLiteral(resourceName: "greenHeart"), for: UIControlState.normal)
        } else {
            cell.heartButton.setImage(#imageLiteral(resourceName: "whiteHeart"), for: UIControlState.normal)
            
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Offer")

        do {
            let results = try context.fetch(fetchRequest)
            let dateCreated = results as! [Offer]
//
//
            for _datecreated in dateCreated {
                let offer = Listing()
                offer.isFavorited = _datecreated.isFavorited
                offer.id = _datecreated.id!
                let imageURL = URL(string:_datecreated.imageURL!)
                //var imageView = UIImageView().kf.setImage(with: imageURL)

                if (offer.id == itemResults[indexPath.row].id && offer.isFavorited == true) {
                    cell.heartButton.setImage(#imageLiteral(resourceName: "greenHeart"), for: UIControlState.normal)
                } else {
                    cell.heartButton.setImage(#imageLiteral(resourceName: "whiteHeart"), for: UIControlState.normal)
            }

            
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }


        var mutableString = NSMutableAttributedString(string: "Eco-Rating")
        mutableString.addAttribute(NSAttributedStringKey.font,
                                   value: UIFont.boldSystemFont(ofSize: 12),
                                   range: NSRange(location:0, length: mutableString.length)
        )
        
        
        if itemResults[indexPath.row].overallRating > 90 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": OUTSTANDING"))
            
            cell.scoreLabel.text = "Eco-Rating: OUTSTANDING"
            //cell.scoreLabel.attributedText = combo
        }
        else if itemResults[indexPath.row].overallRating >= 76 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": EXCELLENT"))
            
            cell.scoreLabel.text = "Eco-Rating: EXCELLENT"
        }   else if itemResults[indexPath.row].overallRating >= 61 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": GREAT"))
            
            cell.scoreLabel.text = "Eco-Rating: GREAT"
            //cell.scoreLabel.attributedText = combo
        }   else  {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": GOOD"))
            
            cell.scoreLabel.text = "Eco-Rating: GOOD"
            //cell.scoreLabel.attributedText = combo
        }
        
        
        let divideValue = CGFloat(itemResults[indexPath.row].overallRating)/100.00
        let dynamicWidth = (cell.frame.width * divideValue) - 30
        let frame = CGRect(x: cell.greenBar.frame.origin.x, y: cell.greenBar.frame.origin.y, width:dynamicWidth , height: cell.greenBar.frame.height)
        
        
        cell.greenBar.frame = frame
        
        
        
        
        return cell//UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissKeyboard()
        
        selectedListing = Listing()
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = itemResults[indexPath.row]
        
        var cell:OfferTableViewCell = tableView.cellForRow(at: indexPath) as! OfferTableViewCell
        
        var myVC = storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        
        myVC.imageURL = selectedListing.image1
        myVC.name = selectedListing.name
        myVC.location = selectedListing.location
        myVC.information = selectedListing.listingDescription
        myVC.isFavorited = false
        myVC.price = selectedListing.price
        myVC.currentListing = selectedListing
        myVC.scoreVal = CGFloat(selectedListing.overallRating)
        
        var mutableString = NSMutableAttributedString(string: "Eco-Rating")
        mutableString.addAttribute(NSAttributedStringKey.font,
                                   value: UIFont.boldSystemFont(ofSize: 12),
                                   range: NSRange(location:0, length: mutableString.length)
        )
        
        if selectedListing.overallRating > 90 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": OUTSTANDING"))
            myVC.ecoRatingScoreLabel.text = "Eco-Rating: OUTSTANDING"
            //cell.scoreLabel.attributedText = combo
        }
        else if selectedListing.overallRating >= 76 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": EXCELLENT"))
            
            myVC.ecoRatingScoreLabel.text = "Eco-Rating: EXCELLENT"
        }   else if selectedListing.overallRating >= 61 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": GREAT"))
            
            myVC.ecoRatingScoreLabel.text = "Eco-Rating: GREAT"
            //cell.scoreLabel.attributedText = combo
        }   else  {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": GOOD"))
            
            myVC.ecoRatingScoreLabel.text = "Eco-Rating: GOOD"
            //cell.scoreLabel.attributedText = combo
        }
        
        let divideValue = CGFloat(itemResults[indexPath.section].overallRating)/100.00
        let dynamicWidth = myVC.scoreBar.frame.width * divideValue
        let frame = CGRect(x: myVC.scoreBar.frame.origin.x, y: myVC.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC.scoreBar.frame.height)
        //print("the green bar dynamic width is \(dynamicWidth)")
        //print("the score fraction to divide/multiply by is \(divideValue)")
        myVC.scoreBar.frame = frame
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    func fetchData(){
        savedListings.removeAll()
        //onlyDateArr.removeAll()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Offer")
        
        do {
            let results = try context.fetch(fetchRequest)
            let dateCreated = results as! [Offer]
            
            
            for _datecreated in dateCreated {
                let offer = Listing()
                offer.name = _datecreated.name!
                offer.location = _datecreated.location!
                offer.isFavorited = _datecreated.isFavorited
                offer.id = _datecreated.id!
                offer.image1 = _datecreated.imageURL!
                offer.price = _datecreated.price!
                offer.stars = Int(_datecreated.stars)
                offer.listingDescription = _datecreated.information!
                //offer.URL = _datecreated.url?
                offer.materialAndResourceScore = Int(_datecreated.materialAndResourceScore)
                offer.managementScore = Int(_datecreated.managementScore)
                offer.communityScore = Int(_datecreated.communityScore)
                offer.waterScore = Int(_datecreated.waterScore)
                offer.recycleAndWaterScore = Int(_datecreated.recycleAndWaterScore)
                offer.energyScore = Int(_datecreated.energyScore)
                offer.indoorsScore = Int(_datecreated.indoorsScore)
                let imageURL = URL(string:_datecreated.imageURL!)
                //var imageView = UIImageView().kf.setImage(with: imageURL)
                
                if offer.isFavorited == true {
                    savedListings.append(offer)
                }
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
}

extension ExploreViewController:UISearchBarDelegate  {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        //view.addGestureRecognizer(tap)
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        //view.removeGestureRecognizer(tap)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        //view.removeGestureRecognizer(tap)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        //view.removeGestureRecognizer(tap)
        
        self.itemResults = Listings

        
        mapButton.isEnabled = true
        if isFiltering {
            filterSearch(sender: nil)
        } else {

            print(searchBar.text)

            SwiftSpinner.show("Searching")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print("Are we there yet?")
                SwiftSpinner.hide()

                self.filtered = self.itemResults.filter({ (item) -> Bool in
                    let location: NSString = item.location as NSString
                    let ratingNew = self.getRating(rating: item.overallRating)
                    
                    let searchText = self.whereSearchBar.text
                    
                    if searchText != "" {
                        
                        var isInContinent = false
                        var continents = [self.AFRICA,self.ASIA,self.EUROPE,self.NORTH_AMERICA,self.SOUTH_AMERICA,self.OCEANIA]
                        
                        for continent in continents {
                            
                            for country in continent.countries {
                                if (continent.name.lowercased().range(of: searchText!.lowercased()) != nil &&
                                    item.location.lowercased().range(of: country.lowercased()) != nil){
                                    
                                    isInContinent = true
                                    print("continent found")
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        if (isInContinent) {
                            print("HERE 1")
                            return true
                        }
                        
                        
                        if (item.location.lowercased().range(of:searchText!.lowercased()) != nil) {
                            print("HERE 2")
                            
                            return true
                        }
                        
                        let range = location.range(of: searchText!, options: .caseInsensitive)
                        if (range.location != NSNotFound) {
                            print("HERE 3")
                            
                            return true
                        } else {
                            
                            return false
                        }
                        
                        
                    } else {
                        if (self.filterPriceOptions.contains(item.price) && self.filterRatingOption.contains(ratingNew)) {
                            return true
                            print("HERE 4")
                            
                        } else {
                            return false
                        }
                        
                        
                    }
                    
                    return false
                    //return range.location != NSNotFound
                })
                if(self.filtered.count == 0){
                    searchActive = false;
                    //no results
                    print("No results")
                    let alertController = UIAlertController(title: "No luck", message: "Check back later", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("OK")
                        self.itemResults = Listings
                    }


                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)


                } else {
                    searchActive = true
                    print("results \(self.filtered)")
                    self.itemResults.removeAll()
                    self.itemResults = self.filtered
                    searchBar.resignFirstResponder()
                    self.addAnnotations()
                    self.tableView.reloadData()
                    self.listingsMapView.showAnnotations(self.listingsMapView.annotations, animated: true)
                }
            }
        }
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.length == 0 {
            //loadListings() SETUPREALM()
            self.itemResults = Listings
            self.tableView.reloadData()
        }
        
    }
    
    func getRating(rating: Int) -> String{
        
        if rating > 90 {
            return "OUTSTANDING"
        }
        else if rating >= 76 {
            return "EXCELLENT"
            
        }   else if rating >= 61 {
            return "GREAT"
        }   else  {
            return "GOOD"
        }
        
    }
    
    
    
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

struct Continent {
    var name : String!
    var countries: [String]!
    
}
