//
//  ProfileViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/8/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UICollectionViewLeftAlignedLayout
import TwitterKit
import FacebookShare
import MessageUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MKMapViewDelegate, UIPopoverPresentationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    

   // @IBOutlet weak var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var nameView: UIView!
    
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    @IBOutlet weak var favoriteActivitiesCollectionView: UICollectionView!
    @IBOutlet weak var bucketListCollectionView: UICollectionView!
    
    @IBOutlet weak var placesVisitedMapView: MKMapView!
    
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var twitterShareButton: UIButton!
    
    
    var places: [String] = []
    //var activities: [String] = []
    var bucketList: [String] = []
    
    var activities = [String]()
    var attractions = [String]()
    var naturalSetting = [String]()
    var hotel = [String]()
    
    var setOfActivities = [[String]]()
    var activityImages = [String]()
    
    var annotations = [MKPointAnnotation]()

    var attributedAboutMeString = NSAttributedString()
    
    var testLabel: UILabel = UILabel()

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true

        
        if let ns = (UserDefaults.standard.value(forKey: "name") as? String) {

        }else{
            let alertController = UIAlertController(title: "Alert", message: "Please login to access this page", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                // ...
                self.tabBarController?.selectedIndex = 0
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                // ...
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                // ...
            }
        }
        
        places = UserDefaults.standard.stringArray(forKey: "placesTraveled") ?? [String]()
        activities = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesDefault") ?? [String]()
        attractions = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesAttractions") ?? [String]()
        naturalSetting = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesNaturalSetting") ?? [String]()
        hotel = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesHotel") ?? [String]()
        
        setOfActivities = [activities,attractions,naturalSetting,hotel]
        activityImages = ["Runner", "attractionActivity", "naturalSettingActivity", "hotelActivity"]
        

        bucketList = UserDefaults.standard.stringArray(forKey: "bucketListArray") ?? [String]()
        
        //var layout = UICollectionViewLeftAlignedLayout()
        
        //bucketListCollectionView.
        
        favoriteActivitiesCollectionView.reloadData()
        bucketListCollectionView.reloadData()
        
        addAnnotations()
        placesVisitedMapView.showAnnotations(annotations, animated: true)
        
        //bucketListCollectionView.collectionViewLayout.invalidateLayout()

        
        print(UserDefaults.standard.string(forKey: "name"))
        print(UserDefaults.standard.string(forKey: "pictureURL"))
        print(UserDefaults.standard.string(forKey: "aboutMe"))
        print(places)
        //print(activities)
        print(bucketList)

        
        if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? Data {
            let image = UIImage(data: profileImage)
            self.profileImage.image =  image
        }
        
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.nameLabel.text = name
        }
        if let aboutMe = UserDefaults.standard.string(forKey: "aboutMe") {
            self.aboutMeTextView.text = aboutMe
        }
        
        // Retrieve array from userdefaults and plot annotations to map
        // Add map tap gesture to open bigger view controller map
        if let whereHaveYouTraveled = UserDefaults.standard.string(forKey: "whereHaveYouTraveled") {
            //self.countriesVisitedTextView.text = whereHaveYouTraveled
        }
        if let favoriteItems = UserDefaults.standard.string(forKey: "favoriteItems") {
            //self.favoriteActivitiesTextView.text = favoriteItems
        }
        if let bucketList = UserDefaults.standard.string(forKey: "bucketList") {
            //self.bucketListTextView.text = bucketList
        }
    
        //attributedAboutMeString.attribute(NSAttributedStringKey.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedAboutMeString.length))
        //aboutMeTextView.attributedText = attributedAboutMeString
        
    }
    
    override func viewDidLayoutSubviews() {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(hex: "61C561")
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        facebookShareButton.layer.cornerRadius = 5
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1172)
        
        self.navigationController?.navigationBar.isHidden = true
        
        favoriteActivitiesCollectionView.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: "activityCell")
        bucketListCollectionView.register(BucketListCollectionViewCell.self, forCellWithReuseIdentifier: "bucketListCell")
        
        
        aboutMeTextView.isEditable = false
        
        favoriteActivitiesCollectionView.delegate = self
        bucketListCollectionView.delegate = self
        
        
        favoriteActivitiesCollectionView.dataSource = self
        bucketListCollectionView.dataSource = self
        
        
        editProfileButton.layer.cornerRadius = 27
        nameView.layer.cornerRadius = 5
        aboutMeTextView.layer.cornerRadius = 5
        placesVisitedMapView.layer.cornerRadius = 5
        
        
        aboutMeTextView.layer.shadowColor = UIColor.black.cgColor
        aboutMeTextView.layer.shadowOpacity = 0.2
        aboutMeTextView.layer.shadowOffset = CGSize(width: 2, height: 2)
        aboutMeTextView.layer.shadowRadius = 1.0
        aboutMeTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        aboutMeTextView.clipsToBounds = false
        
        nameView.layer.shadowColor = UIColor.black.cgColor
        nameView.layer.shadowOpacity = 0.2
        nameView.layer.shadowOffset = CGSize(width: 2, height: 2)
        nameView.layer.shadowRadius = 1.0
        
        placesVisitedMapView.layer.shadowColor = UIColor.black.cgColor
        placesVisitedMapView.layer.shadowOpacity = 0.5
        placesVisitedMapView.layer.shadowOffset = CGSize(width: 2, height: 2)
        placesVisitedMapView.layer.shadowRadius = 1.0
        
        placesVisitedMapView.clipsToBounds = false
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    @IBAction func editProfile(_ sender: Any) {
       // let vc = CustomCellsController()
        //self.present(vc, animated: true, completion: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "editProfile") as! EditProfileViewController
    
        //self.tabBarController?.present(vc, animated: true, completion: nil)
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openSettings(_ sender: Any) {
        
    }
    
    func shared(_ sender: Any) {
        let textToShare = "Hey! Check out this awesome earth friendly travel app called Wayaj! https://itunes.apple.com/us/app/wayaj/id1237768824?mt=8"
        
        if let appURL = NSURL(string: "https://itunes.apple.com/us/app/wayaj/id1237768824?mt=8") {
            let objectsToShare = [textToShare, appURL] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            //Prevents crash on iPads
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        print("shared!")
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
     
        let appURL = URL(string: "https://itunes.apple.com/us/app/wayaj/id1237768824?mt=8")
        let linkCont = LinkShareContent(url: appURL!, title: "Download this amazing earth friendly travel app!", description: "Discover and book eco-friendly hotels and resorts worldwide with Wayaj. From jungle lodges to LEED buildings in major international cities, Wayaj offers the right earth friendly destination to every traveler, no matter what the budget is. All the hotels are rated according to several criteria to ensure they are managed in a sustainable and socially responsible way.", quote: nil, imageURL: nil)
        
        let shareDialog = MessageDialog(content: linkCont)
        shareDialog.completion = { result in
            
        }
        
        do {
            
            try shareDialog.show()
        } catch {
            let alert = UIAlertController(title: "You need to install Facebook Messenger to invite your Facebook Friends", message: "Would you like to install Facebook Messenger?", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                        
                        let fbURL = URL(string: "https://itunes.apple.com/us/app/messenger/id454638411?mt=8")
                        
                        UIApplication.shared.open(fbURL!, options: [:], completionHandler: nil)
                    })
                    alert.addAction(UIAlertAction(title: "No", style: .default) { action in
                        
                    })
            
                    self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func messagesShareButtonTapped(_ sender: Any) {
        
//        let phoneNumber = ""
//        let text = "Some message"
//
//        let text = "Discover and book eco-friendly hotels and resorts worldwide with Wayaj. https://itunes.apple.com/us/app/messenger/id454638411?mt=8"
//        guard let messageAppURL = URL(string: "sms:\(phoneNumber)&body=\(text)")
//        else { return }
//        if UIApplication.shared.canOpenURL(messageAppURL) {
//            UIApplication.shared.open(messageAppURL, options: [:], completionHandler: nil)
//        }
        
        
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = []
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Discover and book eco-friendly hotels and resorts worldwide with Wayaj. https://itunes.apple.com/us/app/wayaj/id1237768824?mt=8"
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func signInWithTwitter() {
        
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            print("SESSION121: \(session)")
            if (session != nil) {
                print("signed121 in as \(session!.userName)")
            } else {
                print("error121: \(error!.localizedDescription)")
            }
        })
        
        
    }
    
    @IBAction func tweetButtonTapped(_ sender: Any) {
        
                let composer = TWTRComposer()
        
                composer.setText("Testing Twitter API")
                composer.setImage(UIImage(named: "twitterkit"))
        
                composer.show(from: self) { (result) in
        
        
                    if (result == .done) {
                        print("Successfully composed Tweet")
                    } else {
                        print("Cancelled composing")
        
                    }
                }
        
        
    }
    
    @IBAction func facebookShareButtonTapped(_ sender: Any) {
        
        let appURL = URL(string: "https://itunes.apple.com/us/app/wayaj/id1237768824?mt=8")
        let linkCont = LinkShareContent(url: appURL!, title: "Download this amazing earth friendly travel app!", description: "Discover and book eco-friendly hotels and resorts worldwide with Wayaj. From jungle lodges to LEED buildings in major international cities, Wayaj offers the right earth friendly destination to every traveler, no matter what the budget is. All the hotels are rated according to several criteria to ensure they are managed in a sustainable and socially responsible way.", quote: nil, imageURL: nil)
        
        let shareDialog = ShareDialog(content: linkCont)
        shareDialog.completion = { result in
            
        }
        
        do {
            
            try shareDialog.show()
        } catch {
            
        }
        
        
        
        
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.bucketListCollectionView {
            
        } else {
            
            
            var popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activityDetailVC") as! ActivitiesDetailViewController
            
            popover.modalPresentationStyle = UIModalPresentationStyle.popover
            popover.popoverPresentationController?.delegate = self
            popover.popoverPresentationController?.sourceView = collectionView.cellForItem(at: indexPath)
            popover.popoverPresentationController?.sourceRect = (collectionView.cellForItem(at: indexPath)?.bounds)!
            popover.activities = setOfActivities[indexPath.row]
            
            if setOfActivities[indexPath.row].count < 10 {
                popover.preferredContentSize = CGSize(width: 200, height: 45 * setOfActivities[indexPath.row].count)
            } else {
                popover.preferredContentSize = CGSize(width: 200, height: 450)
            }
            self.present(popover, animated: true, completion: nil)
            
            
           
            
            
            
            
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.bucketListCollectionView {
            return bucketList.count
        } else {
            
            var count = 0
            
            for item in setOfActivities {
                
                if item.count > 0 { count = count + 1}
                
            }
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.bucketListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bucketListCell", for: indexPath as IndexPath) as! BucketListCollectionViewCell
            

            cell.backgroundColor = UIColor(hex: "61C561")
            cell.layer.cornerRadius = 10
            
            //testLabel.text = bucketList[indexPath.row]
            //testLabel.sizeToFit()
            
            cell.title.text = bucketList[indexPath.row]
            cell.title.sizeToFit()
            cell.title.center = CGPoint(x: cell.bounds.midX, y: cell.bounds.midY)
            
            //cell.title.text = bucketList[indexPath.row]
            //cell.title.sizeToFit()
            //cell.title.center = cell.center
            
            
            //textLabel = UILabel(frame: CGRect(x: 0, y: (self.frame.size.height / 2) - 9, width: self.frame.size.width, height: 18))
            //textLabel.font = UIFont.systemFont(ofSize: 13)
            //textLabel.textColor = .white
            //cell.textLabel.center = cell.center
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath as IndexPath) as! ActivityCollectionViewCell

            var setOfColors = [UIColor(hex: "F5B700"),UIColor(hex: "DC0073"),UIColor(hex: "4EA3FF"),UIColor(hex: "138A36")]
            
            cell.backgroundColor = setOfColors[indexPath.row]
            cell.layer.cornerRadius = 7
            
            //cell.textLabel.text = activities[indexPath.row]
            
            
            if setOfActivities[indexPath.row].count > 0 {
                cell.image.image = UIImage(named: activityImages[indexPath.row])
            }
            
            return cell
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bucketListCollectionView {
            
            
                testLabel.text = bucketList[indexPath.row]
                testLabel.sizeToFit()
            
            
            return CGSize(width: testLabel.frame.width + 20, height: 30)
            
        } else {
            return CGSize(width: 100, height: 100)

        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.bucketListCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func addAnnotations() {
        
        print("IM IN HERE")
        
        
        annotations.removeAll()
        
        
        places.forEach { (place) in
            
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(place) {
                placemarks, error in
                let placemark = placemarks?.first
                
                if let lat = placemark?.location?.coordinate.latitude, let long = placemark?.location?.coordinate.longitude {
                    let location = CLLocation(latitude: lat, longitude: long)
                    let anno = MKPointAnnotation()
                    anno.coordinate = location.coordinate
                    
                    
                    //TODO - custom anno with listing object then open listing when anno is tapped
                    self.placesVisitedMapView.addAnnotation(anno)
                    self.annotations.append(anno)
                }
                
                
                
            }
            
            
        }
        
        annotations.forEach { (anno) in
            //placesVisitedMapView.addAnnotation(anno)
            print(anno)
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
    
 
}

//extension ProfileViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = "cell\(indexPath.section + 1)"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
//        print("the cell is \(identifier)")
//        return cell!//UITableViewCell()
//    }
//    
//}
