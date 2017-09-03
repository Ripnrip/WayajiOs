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
                        Listings = Array(converted)
                        self.itemResults = Array(converted)
                        self.itemResults.shuffle()
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
        cell.priceLabel.text = itemResults[indexPath.section].price
        

        if itemResults[indexPath.section].overallRating >= 90 {
            cell.scoreLabel.text = "Excellent"
        }
        else if itemResults[indexPath.section].overallRating >= 80 {
            cell.scoreLabel.text = "Great"
        }
        else if itemResults[indexPath.section].overallRating >= 40 {
            cell.scoreLabel.text = "Good"
        }

        
        let divideValue = CGFloat(itemResults[indexPath.section].overallRating)/100.00
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = itemResults[indexPath.section]

        var cell:OfferTableViewCell = tableView.cellForRow(at: indexPath) as! OfferTableViewCell

        var myVC = storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController

        myVC.imageURL = selectedListing.image1
        myVC.name = selectedListing.name
        myVC.location = selectedListing.location
        myVC.information = selectedListing.listingDescription
        myVC.isFavorited = false
        myVC.price = selectedListing.price
        myVC.currentListing = selectedListing
        
        let divideValue = CGFloat(itemResults[indexPath.section].overallRating)/100.00
        let dynamicWidth = myVC.scoreBar.frame.width * divideValue
        let frame = CGRect(x: myVC.scoreBar.frame.origin.x, y: myVC.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC.scoreBar.frame.height)
        //print("the green bar dynamic width is \(dynamicWidth)")
        //print("the score fraction to divide/multiply by is \(divideValue)")
        myVC.scoreBar.frame = frame

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
            
            self.filtered = self.itemResults.filter({ (item) -> Bool in
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
                self.itemResults = self.filtered
                self.retractSearchFilter(self)
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }




    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.length == 0 {
            //loadListings() SETUPREALM()
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
            swap(&self[firstUnshuffled], &self[i])
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

