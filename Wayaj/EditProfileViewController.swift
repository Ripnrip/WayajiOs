//
//  EditProfileViewController.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import CLTokenInputView

class EditProfileViewController: UIViewController, CLTokenInputViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var aboutDescriptionView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var placesVisitedView: UIView!
    @IBOutlet weak var favoriteActivitiesView: UIView!
    @IBOutlet weak var bucketListView: UIView!
    
    
    @IBOutlet weak var chooseFavActivitiesButton: UIButton!
    
    @IBOutlet weak var doneInitialButton: UIButton!
    var placesTokenView = CLTokenInputView()
    var activitiesTokenView = CLTokenInputView()
    var bucketListTokenView = CLTokenInputView()
    
    var places = [String]()
    var activities = [String]()
    var bucketList = [String]()
    
    var imageURL:String = ""
    var name:String = ""
    var email:String = ""
    var gender:String = ""
    var image:UIImage = UIImage()
    
    var shouldNotShowQuestionaire:Bool!
    
    let picker = UIImagePickerController()
    
    
    // Add 3 cltokenviews to bucketlist, locations traveled, fav activities
    // 3 arrays to store all values for each
    // Store arrays in userdefaults
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shouldNotShowQuestionaire = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial2"))
        
        if shouldNotShowQuestionaire == false {
            doneInitialButton.isHidden = false
        } else {
            doneInitialButton.isHidden = true
            
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
        
        
        
        bioTextView.text = "Bio"
        bioTextView.textColor = UIColor(hex: "C7C7CD")
        //bioTextView.font = UIFont(name: "Helvetica", size: 16)
        bioTextView.font = UIFont.systemFont(ofSize: 16.5)
        bioTextView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 16)
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
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(hex: "61C561")
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        //NSLayoutConstraint(item: bucketListTokenView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 22.0).isActive = true
        
        //NSLayoutConstraint(item: bucketListTokenView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 10.0).isActive = true
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
        
        if bioTextView.text != "" {
            UserDefaults.standard.setValue(bioTextView.text, forKey: "aboutMe")
        }
        if places.count > 0 {
            UserDefaults.standard.setValue(places, forKey: "placesTraveled")
        }
        
        //UserDefaults.standard.setValue(activities, forKey: "favoriteActivities")
        
        if bucketList.count > 0 {
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
    
    
    @IBAction func doneInitialTapped(_ sender: Any) {
        initialEdit()
    }
    
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.contentMode = .scaleAspectFit //3
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
