//
//  EditProfileViewController.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import CLTokenInputView
import TwitterKit
import Photos
import Social

class EditProfileViewController: UIViewController, CLTokenInputViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var aboutDescriptionView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var placesVisitedView: UIView!
    @IBOutlet weak var favoriteActivitiesView: UIView!
    @IBOutlet weak var bucketListView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    
    var documentController: UIDocumentInteractionController!
    
    @IBOutlet weak var chooseFavActivitiesButton: UIButton!
    
    @IBOutlet weak var doneInitialButton: UIButton!
    var placesTokenView = CLTokenInputView()
    var activitiesTokenView = CLTokenInputView()
    var bucketListTokenView = CLTokenInputView()
    
    var twitterLoggedIn = false
    
   
    var places: [String] = []
    var places2: [String] = []

    //var activities: [String] = []
    var bucketList: [String] = []
    var bucketList2: [String] = []

    
    var activities = [String]()
    var attractions = [String]()
    var naturalSetting = [String]()
    var hotel = [String]()
    var activities2 = [String]()
    var attractions2 = [String]()
    var naturalSetting2 = [String]()
    var hotel2 = [String]()
    var setOfActivities = [[String]]()

    
    var imageURL:String = ""
    var name:String = ""
    var email:String = ""
    var gender:String = ""
    var image:UIImage = UIImage()
    
    var twitterUserID = ""
    
    var shouldNotShowQuestionaire:Bool!
    
    let picker = UIImagePickerController()
    
    var initialTwitter = true
    
    
    // Add 3 cltokenviews to bucketlist, locations traveled, fav activities
    // 3 arrays to store all values for each
    // Store arrays in userdefaults
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shouldNotShowQuestionaire = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial2"))
        
        if shouldNotShowQuestionaire == false {
            doneInitialButton.isHidden = false
            initialTwitter = true
            twitterButton.layer.opacity = 0.4
        } else {
            doneInitialButton.isHidden = true
            initialTwitter = false
            
        }
        //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
        self.navigationController?.navigationBar.isHidden = false
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(self.saveProfile))
        self.navigationItem.rightBarButtonItem  = saveButton
        self.title = "Edit Profile"
        
        picker.delegate = self
        
        loadImage()
        profileImageView.image = image
        
        bucketListTokenView.backgroundColor = .white
        
        
        
        
        placesTokenView.placeholderText = "Where have you previously traveled"
        activitiesTokenView.placeholderText = "What are your favorite activities"
        bucketListTokenView.placeholderText = "What's on your bucket list?"
        placesTokenView.keyboardType = .default
        bucketListTokenView.keyboardType = .default
        
        //print(placesTokenView.placeholderText.debugDescription)
        
        
        placesVisitedView.addSubview(placesTokenView)
        favoriteActivitiesView.addSubview(activitiesTokenView)
        bucketListView.addSubview(bucketListTokenView)
        
        
        
        
        //bucketListTokenView.frame = CGRect(x: 0, y: 0, width: bucketListTokenView.frame.width, height: 80)
        
        bioTextView.delegate = self
        placesTokenView.delegate = self
        activitiesTokenView.delegate = self
        bucketListTokenView.delegate = self
        profileImageView.layer.cornerRadius = 5
        
        
        
        aboutDescriptionView.layer.cornerRadius = 5
        
        bioTextView.layer.shadowColor = UIColor.black.cgColor
        bioTextView.layer.shadowOpacity = 0.2
        bioTextView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bioTextView.layer.shadowRadius = 1.0
        bioTextView.layer.cornerRadius = 5
        bioTextView.clipsToBounds = false
        
        
        placesVisitedView.layer.shadowColor = UIColor.black.cgColor
        placesVisitedView.layer.shadowOpacity = 0.2
        placesVisitedView.layer.shadowOffset = CGSize(width: 0, height: 1)
        placesVisitedView.layer.shadowRadius = 1.0
        placesVisitedView.layer.cornerRadius = 5
        placesVisitedView.clipsToBounds = false
        
        
        bucketListView.layer.shadowColor = UIColor.black.cgColor
        bucketListView.layer.shadowOpacity = 0.2
        bucketListView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bucketListView.layer.shadowRadius = 1.0
        bucketListView.layer.cornerRadius = 5
        chooseFavActivitiesButton.layer.shadowColor = UIColor.black.cgColor
        chooseFavActivitiesButton.layer.shadowOpacity = 0.2
        chooseFavActivitiesButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        chooseFavActivitiesButton.layer.shadowRadius = 1.0
        chooseFavActivitiesButton.layer.cornerRadius = 5
        
        settingsView.layer.shadowColor = UIColor.black.cgColor
        settingsView.layer.shadowOpacity = 0.2
        settingsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        settingsView.layer.shadowRadius = 1.0
        settingsView.layer.cornerRadius = 5
        settingsView.clipsToBounds = false
        
        placesTokenView.layer.cornerRadius = 5
        bucketListTokenView.layer.cornerRadius = 5
        
        bioTextView.layer.borderWidth = 3
        bioTextView.layer.borderColor = UIColor(hex: "D9E8FC").cgColor
        bucketListView.layer.borderWidth = 3
        bucketListView.layer.borderColor = UIColor(hex: "D9E8FC").cgColor
        placesVisitedView.layer.borderWidth = 3
        placesVisitedView.layer.borderColor = UIColor(hex: "D9E8FC").cgColor
        chooseFavActivitiesButton.layer.borderWidth = 3
        chooseFavActivitiesButton.layer.borderColor = UIColor(hex: "D9E8FC").cgColor
        settingsView.layer.borderWidth = 3
        settingsView.layer.borderColor = UIColor(hex: "D9E8FC").cgColor
        
        
        if let aboutMe = UserDefaults.standard.string(forKey: "aboutMe") {
            self.bioTextView.text = aboutMe
        } else {
            bioTextView.text = "Bio"
            bioTextView.textColor = UIColor(hex: "3D444E")
            //bioTextView.font = UIFont(name: "Helvetica", size: 16)
            bioTextView.font = UIFont.systemFont(ofSize: 16.5)
            bioTextView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 16)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        placesTokenView.frame = CGRect(x: 0, y: 0, width: placesVisitedView.frame.width, height: placesVisitedView.frame.height)
        placesTokenView.backgroundColor = .white
        activitiesTokenView.frame = CGRect(x: 0, y: 0, width: favoriteActivitiesView.frame.width, height: favoriteActivitiesView.frame.height)
        activitiesTokenView.backgroundColor = .white
        
        bucketListTokenView.frame = CGRect(x: 0, y: 0, width: bucketListView.frame.width, height: bucketListView.frame.height)
        
        twitterButton.imageView?.contentMode = .scaleAspectFit

        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(hex: "61C561")
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        //NSLayoutConstraint(item: bucketListTokenView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 22.0).isActive = true
        
        //NSLayoutConstraint(item: bucketListTokenView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 10.0).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Twitter.sharedInstance().sessionStore.session() != nil {
            self.twitterLoggedIn = true
            self.twitterButton.alpha = 1.0
            UserDefaults.standard.set(true, forKey: "twitterIntegrated")
            print("TWITT LOGGED IN")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePictureButtonTapped(_ sender: Any) {
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func tokenInputView(_ view: CLTokenInputView, didChangeText text: String?) {
        
        
        
    }
    
    func tokenInputViewDidBeginEditing(_ view: CLTokenInputView) {
        if view == bucketListTokenView {
            scrollView.scrollToBottom()
        }
        
    }
    
    func tokenInputViewDidEndEditing(_ view: CLTokenInputView) {
        if view == bucketListTokenView {
            scrollView.scrollToTop()
        }
        
    }
    
    func tokenInputView(_ view: CLTokenInputView, didAdd token: CLToken) {
        
        if view == placesTokenView {
            
            places.append(token.displayText)
            
        } else if view == activitiesTokenView {
            activities.append(token.displayText)
            
        } else {
            bucketList.append(token.displayText)
        }
        
        
    }
    
    func tokenInputView(_ view: CLTokenInputView, didRemove token: CLToken) {
        if view == placesTokenView {
            
            var cnt = 0
            for place in places {
                if place == token.displayText {
                    places.remove(at: cnt)
                }
                cnt = cnt + 1
            }
            
        } else if view == activitiesTokenView {
            var cnt = 0
            for activity in activities {
                if activity == token.displayText {
                    activities.remove(at: cnt)
                }
                cnt = cnt + 1
            }
        } else {
            var cnt = 0
            for bucket in bucketList {
                if bucket == token.displayText {
                    bucketList.remove(at: cnt)
                }
                cnt = cnt + 1
            }
            
        }
    }
    
    
    func tokenInputViewShouldReturn(_ view: CLTokenInputView) -> Bool {
        if view == placesTokenView {
            
            var tok = CLToken(displayText: view.text!, context: nil)
            placesTokenView.add(tok)
            
            
        } else if view == activitiesTokenView {
            var tok = CLToken(displayText: view.text!, context: nil)
            activitiesTokenView.add(tok)
            
        } else {
            var tok = CLToken(displayText: view.text!, context: nil)
            bucketListTokenView.add(tok)
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == UIColor(hex: "C7C7CD") {
            bioTextView.text = nil
            bioTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text.isEmpty {
            bioTextView.text = "Bio"
            bioTextView.textColor = UIColor(hex: "C7C7CD")
        }
    }
    
    @objc func saveProfile() {
        
        UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial2")
        
        places2 = UserDefaults.standard.stringArray(forKey: "placesTraveled") ?? [String]()
        activities2 = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesDefault") ?? [String]()
        attractions2 = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesAttractions") ?? [String]()
        naturalSetting2 = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesNaturalSetting") ?? [String]()
        hotel2 = UserDefaults.standard.stringArray(forKey: "favoriteActivitiesHotel") ?? [String]()
        bucketList2 = UserDefaults.standard.stringArray(forKey: "bucketListArray") ?? [String]()

        
        setOfActivities = [activities,attractions,naturalSetting,hotel]
        
        if bioTextView.text != "" || bioTextView.text != "Bio" {
            UserDefaults.standard.setValue(bioTextView.text, forKey: "aboutMe")
        }
        if places.count > 0 {
            for place in places2 {
                places.append(place)
            }
            UserDefaults.standard.setValue(places, forKey: "placesTraveled")
        }
        
        //UserDefaults.standard.setValue(activities, forKey: "favoriteActivities")
        
        if bucketList.count > 0 {
            for bucket in bucketList2 {
                bucketList.append(bucket)
            }
            UserDefaults.standard.setValue(bucketList, forKey: "bucketListArray")
        }
        
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        if imageData != nil {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: "Profile updated!", message: "Click \"Continue\" to continue", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { action in
            if self.shouldNotShowQuestionaire == false {
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                self.navigationController?.popViewController(animated: true)
                
            }
        })
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func loadImage(){
        self.name = FacebookIdentityProfile.sharedInstance().userName!
        
        if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? Data {
            if let image = UIImage(data: profileImage) {
                self.image =  image
            }
            
        }
    }
    
    func initialEdit(){
        UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial2")
        saveProfile()
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        
        
        //InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: UIImage(named: "Rainforest")! , instagramCaption: "Testing API", view: self.view)
        
        DispatchQueue.main.async {
            
            //Share To Instagrma:
            
            let instagramURL = URL(string: "instagram://camera")
            
            if UIApplication.shared.canOpenURL(instagramURL!) {
                
                let imageData = UIImageJPEGRepresentation(UIImage(named: "Rainforest")!, 100)
                
                let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(".igo")
                
                do {
                    try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                    
                } catch {
                    
                    print(error)
                }
                
                UIApplication.shared.open(instagramURL!, options: [:], completionHandler: nil)
                
//                let fileURL = URL(fileURLWithPath: writePath)
//
//                self.documentController = UIDocumentInteractionController(url: fileURL)
//
//                self.documentController.delegate = self
//
//                self.documentController.uti = "com.instagram.exclusivegram"
//
//                if UIDevice.current.userInterfaceIdiom == .phone {
//
//                    self.documentController.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
//                } else {
//
//                    //self.documentController.presentOpenInMenu(from: self.instagramButton, animated: true)
//
//                }
                
                
            } else {
                
                print(" Instagram is not installed ")
            }
        }

        
        

        
//        let composer = TWTRComposer()
//
//        composer.setText("Testing Twitter API")
//        composer.setImage(UIImage(named: "twitterkit"))
//
//        composer.show(from: self) { (result) in
//
//
//            if (result == .done) {
//                print("Successfully composed Tweet")
//            } else {
//                print("Cancelled composing")
//
//            }
//        }
//
        
//        let alert = UIAlertController(title: "Instagram coming soon!", message: "Instragram integration coming soon! You'll soon be able to connect with your fellow instagrammers!", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
//        })
//        
//        self.present(alert, animated: true, completion: nil)

        
    }
   
    
    func signInWithTwitter() {
        
        if !UserDefaults.standard.bool(forKey: "twitterIntegrated") {
        
            Twitter.sharedInstance().logIn(completion: { (session, error) in
                print("SESSION121: \(session)")
                if (session != nil) {
                    self.twitterUserID = session!.userID
                } else {
                    print("error121: \(error!.localizedDescription)");
                }
            })
            
            
        } else {
            
            
            let alert = UIAlertController(title: "Twitter logged in.", message: "You are already connected to Twitter. Would you like to disconnect?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                UserDefaults.standard.set(false, forKey: "twitterIntegrated")
                self.twitterButton.alpha = 0.4
                Twitter.sharedInstance().sessionStore.logOutUserID(self.twitterUserID)
            })
            alert.addAction(UIAlertAction(title: "No", style: .default) { action in
                //UserDefaults.standard.set(true, forKey: "twitterIntegrated")
            })
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
        if !initialTwitter {
            signInWithTwitter()
        } else {
            let alert = UIAlertController(title: "Save profile to continue", message: "You can integrate Twitter at a later time. Visit your settings later to integrate Twitter", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func profileTypeValueChanged(_ sender: Any) {
    }
    
    @IBAction func notificationsValueChanged(_ sender: Any) {
    }
    
    
    @IBAction func doneInitialTapped(_ sender: Any) {
        initialEdit()
    }
    
    
    
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.contentMode = .scaleAspectFill //3
        profileImageView.image = chosenImage //4
        image = chosenImage
        dismiss(animated:true, completion: nil) //5
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func chooseActivitiesButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toActivitiesSegue", sender:self)
        
        
        //        if shouldNotShowQuestionaire == false {
        //        } else {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        let activitiesPage = storyBoard.instantiateViewController(withIdentifier: "activitiesPage") as! ActivitiesPageViewController
        //
        //        DispatchQueue.main.async {
        //            self.navigationController?.present(activitiesPage, animated: true, completion: nil)
        //        }
        //
        //        }
        //
    }
    
    
    
    
    
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    
    // Bonus: Scroll to top
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: true)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
