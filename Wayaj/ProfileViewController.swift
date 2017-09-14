//
//  ProfileViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/8/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

   // @IBOutlet weak var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var countriesVisitedTextView: UITextView!
    @IBOutlet weak var favoriteActivitiesTextView: UITextView!
    @IBOutlet weak var bucketListTextView: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        print(UserDefaults.standard.string(forKey: "name"))
        print(UserDefaults.standard.string(forKey: "pictureURL"))
        print(UserDefaults.standard.string(forKey: "aboutMe"))
        print(UserDefaults.standard.string(forKey: "whereHaveYouTraveled"))
        print(UserDefaults.standard.string(forKey: "favoriteItems"))
        print(UserDefaults.standard.string(forKey: "bucketList"))

        
        if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? NSData {
            let image = NSKeyedUnarchiver.unarchiveObject(with: profileImage as Data) as! UIImage
            self.profileImage.image =  image
        }
        
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.nameLabel.text = name
        }
        if let aboutMe = UserDefaults.standard.string(forKey: "aboutMe") {
            self.aboutMeTextView.text = aboutMe
        }
        if let whereHaveYouTraveled = UserDefaults.standard.string(forKey: "whereHaveYouTraveled") {
            self.countriesVisitedTextView.text = whereHaveYouTraveled
        }
        if let favoriteItems = UserDefaults.standard.string(forKey: "favoriteItems") {
            self.favoriteActivitiesTextView.text = favoriteItems
        }
        if let bucketList = UserDefaults.standard.string(forKey: "bucketList") {
            self.bucketListTextView.text = bucketList
        }
    
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1029)
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    @IBAction func editProfile(_ sender: Any) {
        let vc = CustomCellsController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func openSettings(_ sender: Any) {
        
    }

    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        let textToShare = "Hey! Check out this awesome earth friendly travel app calle Wayaj!"
        
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
