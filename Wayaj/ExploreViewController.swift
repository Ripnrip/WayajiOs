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
import Kingfisher

struct AllListings {
    static var listings = [Listing]()
}


final class Listing: Object {
    dynamic var id: String = ""
    dynamic var image1:String = ""
    dynamic var image2:String = ""
    dynamic var image3:String = ""
    dynamic var image4:String = ""
    dynamic var name:String = ""
    dynamic var location:String = ""
    dynamic var stars: Int = 0
    dynamic var isFavorited:Bool = false
    dynamic var URL:String = ""
    dynamic var listingDescription:String = ""
    dynamic var completed = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

var Listings = [Listing]()
var locationsArray = [String]()




var selectedListing = Listing()
var searchActive : Bool = false


class ExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var whereSearchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var whereButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keywordButton: UIButton!
    @IBOutlet weak var whenButton: UIButton!
    @IBOutlet weak var howManyButton: UIButton!

    var player: AVAudioPlayer?

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

    lazy var datePicker: AirbnbDatePicker = {
        let btn = AirbnbDatePicker()
        btn.frame = CGRect(x: 19, y: 137.67, width: 337, height: 49)
        //btn.translatesAutoresizingMaskIntoConstraints = false
        btn.delegate = self
        return btn
        
    }()
    
    lazy var occupantFilter: AirbnbOccupantFilter = {
        let btn = AirbnbOccupantFilter()
        btn.frame = CGRect(x: 25, y: 197, width: 300, height: 49)
        //btn.translatesAutoresizingMaskIntoConstraints = false
        btn.delegate = self
        return btn
    }()
    
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

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        whereSearchBar.delegate = self
        let textFieldInsideSearchBar = whereSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        self.upButton.isHidden = true
        //self.whereButton.isHidden = true
        datePicker.isHidden = true
        occupantFilter.isHidden = true
        loadListings()
        
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
        
        setupRealm()

    }

    func shouldShowQuestionare(){
        let shouldNotShowQuestionaire:Bool = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial2"))
        if let name:String = (UserDefaults.standard.value(forKey: "name") as? String) {
            if shouldNotShowQuestionaire == false && name.length > 1 {
                let vc = CustomCellsController()
                vc.name = UserDefaults.standard.value(forKey: "name") as! String
                //vc.email = UserDefaults.standard.value(forKey: "email") as! String
                vc.gender = UserDefaults.standard.value(forKey: "gender") as! String
                let usersImageUrl = UserDefaults.standard.value(forKey: "pictureURL") as! String
                
                self.getDataFromUrl(url: URL(string:usersImageUrl)!, completion: { (data, response, error) in
                    if error == nil {
                        vc.image = UIImage(data: data!)!
                        SwiftSpinner.hide()
                        self.present(vc, animated: true, completion: nil)
                    }else {
                        print("there was an error getting the picure url \(error)")
                    }
                })
                
                
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
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
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

        let listing1 = Listing()
        listing1.id = "16"
        listing1.name = "L'Auberge Del Mar"
        listing1.image1 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+MAr-+Suite.jpg"
        listing1.image2 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Cabana+Accommodations.jpg"
        listing1.image3 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Spa.jpg"
        listing1.image4 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar.jpg"
        listing1.location = "Del Mar, California"
        listing1.stars = 4
        listing1.isFavorited = false
        listing1.URL = "https://www.tripadvisor.com/Hotel_Review-g32286-d76752-Reviews-L_Auberge_Del_Mar-Del_Mar_California.html"
        listing1.listingDescription = "Experience the best California has to offer at this fabulous beach resort located in the heart of Southern California's most picturesque coastal village of Del Mar in San Diego's North County. L’Auberge du Mar features 121 deluxe guest rooms, including 7 well-appointed luxury suites, offer Del Mar Village views, coastal ocean views, and/or garden terrace views in a luxurious beach estate setting. Local attractions include the Encinitas Tide pools, tours of local Temecula wineries and the San Diego Polo Fields. Fresh and health conscious, the restaurant menus at L'Auberge Del Mar showcase local, organic produce, and sustainable seafood."
        
        let Listing2 = Listing()
        Listing2.id = "17"
        Listing2.name = "Inspira Santa Marta Hotel"
        Listing2.image1 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+MArta+Hotel-+Suite.jpg"
        Listing2.image2 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+Marta+Hotel+-+Jaccuzzi.jpg"
        Listing2.image3 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+Marta+Hotel.jpg"
        Listing2.image4 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+marta+Hotel-+Bedroom.jpg"
        Listing2.location = "Lisbon, Portugal"
        Listing2.stars = 4
        Listing2.isFavorited = false
        Listing2.URL = "https://www.tripadvisor.com/Hotel_Review-g189158-d1580631-Reviews-Inspira_Santa_Marta_Hotel-Lisbon_Lisbon_District_Central_Portugal.html"
        Listing2.listingDescription = "Behind its austere neoclassical facade, an oasis of peace and harmony welcomes the guests of the Santa Marta Hotel. Located in the historical center of Lisbon, the hotel has been completely designed following the principles of Feng Shui, so that mind and body can be revitalized and regenerated by the surrounding flow of positive energies. Not only the five basic elements of Feng-Shui, metal, wood, fire, water and earth, are always present, but the furniture has been carefully chosen and the location of each space and its inherent functions also respect its principles of Feng Shui."
        
        let Listing3 = Listing()
        Listing3.id = "18"
        Listing3.name = "Mauna Lani"
        Listing3.image1 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/Mauna+Lani+Bay-+Bedroom.jpg"
        Listing3.image2 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/Mauna+Lani+Bay-+Spa.jpg"
        Listing3.image3 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/mauna+Lani+Resort.jpg"
        Listing3.image4 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/mauna+Lani+Resort.jpg"
        Listing3.location = "Waimea, Hawaii"
        Listing3.stars = 4
        Listing3.isFavorited = false
        Listing3.URL = "https://www.tripadvisor.com/Hotel_Review-g2312116-d111599-Reviews-Mauna_Lani_Bay_Hotel_Bungalows-Puako_Kohala_Coast_Island_of_Hawaii_Hawaii.html"
        Listing3.listingDescription = "Nestled oceanfront on a sandy beach of Kohala Coast the Mauna Lani Bay Hotel & Bungalows is recognized as a pacesetter in historic preservation and stewardship of the land.  Guests experience the rich history and culture of the Big Island of Hawaii, through a myriad of resort activities like exploring the historic Kalahuiupua'a fishponds, play a round of golf, learn to play a ukulele, or hike through Hawaii’s largest petroglyph field. Accommodations include ocean front or ocean view bungalows, as well as rooms and suites in the resort’s main building."
        
        let listing4 = Listing()
        listing4.id = "19"
        listing4.name = "L'Auberge Del Mar"
        listing4.image1 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+MAr-+Suite.jpg"
        listing4.image2 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Cabana+Accommodations.jpg"
        listing4.image3 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Spa.jpg"
        listing4.image4 = "https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar.jpg"
        listing4.location = "Del Mar, California"
        listing4.stars = 4
        listing4.isFavorited = false
        listing4.URL = "https://www.tripadvisor.com/Hotel_Review-g32286-d76752-Reviews-L_Auberge_Del_Mar-Del_Mar_California.html"
        listing4.listingDescription = "Experience the best California has to offer at this fabulous beach resort located in the heart of Southern California's most picturesque coastal village of Del Mar in San Diego's North County. L’Auberge du Mar features 121 deluxe guest rooms, including 7 well-appointed luxury suites, offer Del Mar Village views, coastal ocean views, and/or garden terrace views in a luxurious beach estate setting. Local attractions include the Encinitas Tide pools, tours of local Temecula wineries and the San Diego Polo Fields. Fresh and health conscious, the restaurant menus at L'Auberge Del Mar showcase local, organic produce, and sustainable seafood."
        
        let listing5 = Listing()
        listing5.id = "20"
        listing5.name = "Inspira Santa Marta Hotel"
        listing5.image1 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+MArta+Hotel-+Suite.jpg"
        listing5.image2 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+Marta+Hotel+-+Jaccuzzi.jpg"
        listing5.image3 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+Marta+Hotel.jpg"
        listing5.image4 = "https://s3.amazonaws.com/my-test-bucket9983/Inspira+Santa+Marta+Hotel-+Portugal--/Inspira+Santa+marta+Hotel-+Bedroom.jpg"
        listing5.location = "Lisbon, Portugal"
        listing5.stars = 4
        listing5.isFavorited = false
        listing5.URL = "https://www.tripadvisor.com/Hotel_Review-g189158-d1580631-Reviews-Inspira_Santa_Marta_Hotel-Lisbon_Lisbon_District_Central_Portugal.html"
        listing5.listingDescription = "Behind its austere neoclassical facade, an oasis of peace and harmony welcomes the guests of the Santa Marta Hotel. Located in the historical center of Lisbon, the hotel has been completely designed following the principles of Feng Shui, so that mind and body can be revitalized and regenerated by the surrounding flow of positive energies. Not only the five basic elements of Feng-Shui, metal, wood, fire, water and earth, are always present, but the furniture has been carefully chosen and the location of each space and its inherent functions also respect its principles of Feng Shui."
        
        let listing6 = Listing()
        listing6.id = "21"
        listing6.name = "Mauna Lani"
        listing6.image1 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/Mauna+Lani+Bay-+Bedroom.jpg"
        listing6.image2 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/Mauna+Lani+Bay-+Spa.jpg"
        listing6.image3 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/mauna+Lani+Resort.jpg"
        listing6.image4 = "https://s3.amazonaws.com/my-test-bucket9983/Mauna+Lani+Resort-Hawaii--/mauna+Lani+Resort.jpg"
        listing6.location = "Waimea, Hawaii"
        listing6.stars = 4
        listing6.isFavorited = false
        listing6.URL = "https://www.tripadvisor.com/Hotel_Review-g2312116-d111599-Reviews-Mauna_Lani_Bay_Hotel_Bungalows-Puako_Kohala_Coast_Island_of_Hawaii_Hawaii.html"
        listing6.listingDescription = "Nestled oceanfront on a sandy beach of Kohala Coast the Mauna Lani Bay Hotel & Bungalows is recognized as a pacesetter in historic preservation and stewardship of the land.  Guests experience the rich history and culture of the Big Island of Hawaii, through a myriad of resort activities like exploring the historic Kalahuiupua'a fishponds, play a round of golf, learn to play a ukulele, or hike through Hawaii’s largest petroglyph field. Accommodations include ocean front or ocean view bungalows, as well as rooms and suites in the resort’s main building."
        
/*
        let listing4 = Listing(image: #imageLiteral(resourceName: "markSpencerHotel"), images: ["https://s3.amazonaws.com/my-test-bucket9983/Mark+Spencer-+Portland--/Mark+Spencer+Hotel-+Lobby.jpg","https://s3.amazonaws.com/my-test-bucket9983/Mark+Spencer-+Portland--/Mark+Spencer+Hotel-+Suit.jpg","https://s3.amazonaws.com/my-test-bucket9983/Mark+Spencer-+Portland--/Mark+Spencer+Hotel-bedroom.jpg","https://s3.amazonaws.com/my-test-bucket9983/Mark+Spencer-+Portland--/Mark+Spencer.jpg"], name: "Mark Spencer Hotel", location: "Portland, Oregon", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g52024-d96156-Reviews-Mark_Spencer_Hotel-Portland_Oregon.html"), description: "If you're heading to Portland, Oregon, the Mark Spencer Hotel is the perfect choice for your stay. All the 101 guest rooms and suites have been beautifully renovated and redesigned to combine modern décor with the historic local character, thus creating a luxurious and comfortable atmosphere for any business or leisure traveler. Amenities include daily complimentary continental breakfast with selection of espresso coffees, afternoon tea and cookies, evening wine reception and 24 hour fitness center.")
        let listing5 = Listing(image: #imageLiteral(resourceName: "hotelSkylar"), images: ["https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+MAr-+Suite.jpg","https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Cabana+Accommodations.jpg","https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar-+Spa.jpg","https://s3.amazonaws.com/my-test-bucket9983/L'Auberge+Del+Mar-CA--/L'Auberge+Del+Mar.jpg"] , name: "Hotel Skylar", location: "Syracuse, New York", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g48713-d2138174-Reviews-Hotel_Skyler-Syracuse_Finger_Lakes_New_York.html"), description: "Syracuse’s first LEED Platinum hotel is a unique combination of industrial minimalism and soothing organic touches. Retro and metro mingle in their original guest rooms that are as eclectic as they are comfortable. From the moment you digitally check in until you reluctantly say goodbye, you’ll know you’re somewhere specially designed to nurture your spirit while protecting the planet. ")
        let listing6 = Listing(image: #imageLiteral(resourceName: "CayoBeach"), images: ["https://s3.amazonaws.com/my-test-bucket9983/Cayo+Arena+Beach+Eco+Hotel-+DR/Cayo+Arena+BEach+Eco+Hotel-+BEdroom.jpg","https://s3.amazonaws.com/my-test-bucket9983/Cayo+Arena+Beach+Eco+Hotel-+DR/Cayo+Arena+Beach+Eco+Hotel.jpg"], name: "Cayo Arena Beach Eco Hotel", location: "Cayo, Dominican Republic", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g4156412-d7335762-Reviews-Cayo_Arena_Beach_EcoHotel-Punta_Rucia_Puerto_Plata_Province_Dominican_Republic.html"), description: "With only four beach front rooms, the Cayo Arena Beach is the ideal destination for a quiet vacation immersed in nature. The nearby Punta Rucia is home to a spectacular coral reef with crystalline waters inhabited by turtles, nurse sharks, eagle rays and dolphins. Discovered only in 1994 El Salto de la Damajagua features a spectacular hike through lagoons and waterfalls hidden in the central mountain range. Other the local attractions include the Manati National Park and a pristine mangrove area that can be explored by canoe.")
        let listing7 = Listing(image: #imageLiteral(resourceName: "CasaSol"), images: ["https://s3.amazonaws.com/my-test-bucket9983/casa+sol/Casa+Sol+Bed+and+Breakfast-+Common+Area.jpg","https://s3.amazonaws.com/my-test-bucket9983/casa+sol/Casa+Sol+Bed+and+Breakfast-Bedroom.jpg","https://s3.amazonaws.com/my-test-bucket9983/casa+sol/Casa+Sol.jpg"], name: "Casa Sol Bed and Breakfast", location: "San Juan, Puerto Rico", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g147320-d5964475-Reviews-Casa_Sol_Bed_and_Breakfast-San_Juan_Puerto_Rico.html"), description: "Caressed by the warm winds of the Atlantic and surrounded by history and culture, Casa Sol is the first Bed & Breakfast located right in the heart of Old San Juan, Puerto Rico. Its guests enjoy the experience of lodging in a colonial building built in the eighteenth century, which has been restored and decorated to reach a modern ambiance. Casa Sol counts with five rooms exquisitely decorated with a Spanish style, a flair like that of a boutique hotel. They all have an A/C unit and USB port next to bed side table. And don’t miss their complimentary homemade breakfast served in the spacious interior courtyard! ")
        let listing8 = Listing(image: #imageLiteral(resourceName: "Rainforest"), images: ["https://s3.amazonaws.com/my-test-bucket9983/Rainforest+Inn+Bed+%26+Breakfast-PR-/Rainforest+In+Bed+and+Breakfast-+Chalet.jpg","https://s3.amazonaws.com/my-test-bucket9983/Rainforest+Inn+Bed+%26+Breakfast-PR-/Rainforest+Inn+Bed+%26+Breakfast.jpg","https://s3.amazonaws.com/my-test-bucket9983/Rainforest+Inn+Bed+%26+Breakfast-PR-/Rainforest+Inn+Bed+and+Breakfast-+Suite.jpg"], name: "Rainforest Inn Bed & Breakfast", location: "El Yunque, Puerto Rico", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g147324-d503287-Reviews-Rainforest_Inn-El_Yunque_National_Forest_Puerto_Rico.html"), description: "Elegant, secluded, and enveloped by the jungle, The Rainforest Inn Bed and Breakfast offers an ideal getaway to those who are looking for a luxurious vacation immersed in nature and local culture. Tucked away on the Northern edge of the El Yunque National Forest, at these rustic boutique style villas furnished with antiques you can experience a touch of luxury while footsteps from one of the most impressive natural sites in the United States. Amenities include complimentary vegetarian breakfast, yoga room and a natural koi pond.")
        let listing9 = Listing(image: #imageLiteral(resourceName: "innByTheSea"), images: ["https://s3.amazonaws.com/my-test-bucket9983/inn+by+the+sea+-+maine/innbythesea-bedroom.jpg","https://s3.amazonaws.com/my-test-bucket9983/inn+by+the+sea+-+maine/innbythesea-main-bldg.jpg","https://s3.amazonaws.com/my-test-bucket9983/inn+by+the+sea+-+maine/innbythesea-room1.jpg","https://s3.amazonaws.com/my-test-bucket9983/inn+by+the+sea+-+maine/innbythesea-spa.jpg","https://s3.amazonaws.com/my-test-bucket9983/inn+by+the+sea+-+maine/innbythesea-suite.jpg"], name: "Inn By The Sea", location: "Cape Elizabeth, Maine", stars: 4, isFavorited: false, URL: URL(string: "https://www.tripadvisor.com/Hotel_Review-g40554-d198688-Reviews-Inn_by_the_Sea-Cape_Elizabeth_Maine.html"), description: "Named among the top 10 US green hotels by Forbes Traveler and MSNBC, the Inn by the Sea features beach front luxury accomodations in a modern and relaxed atmosphere. With 61 guest rooms, suites and cottages, this unique Maine resort offers the ideal getaway for everyone, couples, families or groups. Located in the historic town of Cape Elizabeth, just 15 minutes from Portland, Inn by the Sea caters a great range of activities for its guests, including food, natural and cultural tours of the area. Enjoy your view of Crescent Beach from the comfort of your luxuriously appointed room or suite, and make sure you leave time for serene relaxation. Inn Activities include nightly fire pits, beachfront sunsets, early morning yoga and garden tours courtesy of the Inn's head gardener, Derrick Daly. Our beach front luxury hotel has been nationally recognized for green hotel practices, including a LEED Silver certified Spa. Inn by the Sea is also well known as a pet-friendly destination in the Portland area, so please bring your four legged companions with you! The Spa at Inn by the Sea is ready to spoil you with Signature Treatments, Massage Therapies, Facial Treatments, and Body Therapies. Come to relax for an hour or a day of restorative spa treatments that will leave you feeling rejuvenated and refreshed. The Inn also offers event space for your business or social gathering, and features a signaturerestaurant,Sea Glass. Portland, Maine is known for exquisite dining, and the Sea Glass restaurant is no exception. Enjoy the oceanfront view while you dine on Executive Chef Andrew Chadwick's latest creations, featuring fresh, local seafood and produce. Whether for a weekend getaway, wedding celebration at the beach or group meeting, you will experience a Maine destination where luxury comes naturally.")
        Listings = [listing1,listing2,listing3,listing4,listing5,listing6,listing7,listing8,listing9]
 */
        Listings = [listing1,Listing2,Listing3,listing4,listing5,listing6]
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
            self.datePicker.isHidden = false
            self.occupantFilter.isHidden = false
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
        self.datePicker.isHidden = true
        self.occupantFilter.isHidden = true
        //self.whereSearchBar.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame = CGRect(x: 19, y: 28, width: 337, height: 47)
            self.tableView.frame = CGRect(x: 0, y: 98, width: self.view.frame.width, height: self.view.frame.size.height)
        }, completion: {
            (value: Bool) in
            //self.blurBg.hidden = true
            self.upButton.isHidden = true
            //self.whereButton.isHidden = true


        })

    }
    
    @IBAction func whereSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.whereSearchBar.frame = CGRect(x: self.whereButton.frame.origin.x + 100, y: self.whereButton.center.y - 22  , width: 240, height: 44)
            
        }
        
        
    }
    
    @IBAction func whenSearch(_ sender: Any) {
        
    }
    
    @IBAction func howManySearch(_ sender: Any) {
        
    }
    
    @IBAction func keywordSearch(_ sender: Any) {
        
    }
    
    
    //MARK: Realm
    func setupRealm() {
        // Log in existing user with username and password
        let username = "gurinder@beeback.io"  // <--- Update this
        let password = "Binarybros1"  // <--- Update this
        
        var fetchedItems =
            
            
            SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://ec2-34-230-65-31.compute-1.amazonaws.com:9080")!) { user, error in
                guard let user = user else {
                    fatalError(String(describing: error))
                }
                
                DispatchQueue.main.async {
                    // Open Realm
                    let configuration = Realm.Configuration(
                        syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://ec2-34-230-65-31.compute-1.amazonaws.com:9080/4ca6917f529505872e6260600cf0d7ae/realmListings")!)
                    )
                    self.realm = try! Realm(configuration: configuration)
                    
                    
                    
                    print("all the objects are \(self.realm.objects(Listing.self))")
                    
                    // Show initial tasks
                    func updateList() {
                        let results = self.realm.objects(Listing.self)
                        let converted = results.reduce(List<Listing>()) { (list, element) -> List<Listing> in
                            if element.completed == true {
                                list.append(element)
                            }
                            return list
                        }
                        
                        if self.items.realm == nil  {
                            self.items = converted
                        }
                        self.itemResults = Array(results)
                        self.tableView.reloadData()
                    }
                    updateList()
                    
                    // Notify us when Realm changes
                    self.notificationToken = self.realm.addNotificationBlock { _ in
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
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferTableViewCell
        cell.listingObject = itemResults[indexPath.section]
        let imageURL = URL(string:itemResults[indexPath.section].image1)
        cell.offerImage.kf.setImage(with: imageURL)
        cell.nameLabel.text = itemResults[indexPath.section].name
        cell.locationLabel.text = itemResults[indexPath.section].location
        cell.id = itemResults[indexPath.section].id
        
        return cell//UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissKeyboard()
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = Listings[indexPath.section]
        //self.performSegue(withIdentifier: "viewOffer", sender: nil)
        //self.performSegue(withIdentifier: "viewTripAdvisorListing", sender: nil)
        let myVC = storyboard?.instantiateViewController(withIdentifier: "offerPageDetail") as! OfferPageViewController
        myVC.currentListing = selectedListing
        myVC.bookURL = URL(string:selectedListing.URL)
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: selectedListing.image1))
        myVC.image = imageView.image
        myVC.descriptionText = selectedListing.listingDescription
        self.navigationController?.pushViewController(myVC, animated: true)

        
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

        print(searchBar.text)
        
        SwiftSpinner.show("Searching")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("Are we there yet?")
            SwiftSpinner.hide()
            
            self.filtered = Listings.filter({ (item) -> Bool in
                let tmp: NSString = item.location as NSString
                let range = tmp.range(of: searchBar.text!, options: .caseInsensitive)
                return range.location != NSNotFound
            })
            if(self.filtered.count == 0){
                searchActive = false;
                //no results
                print("No results")
                let alertController = UIAlertController(title: "No luck", message: "Check back later", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                searchActive = true
                print("results \(self.filtered)")
                Listings = self.filtered
                self.retractSearchFilter(self)
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }




    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.length == 0 {
            loadListings()
        }

    }

    
}

