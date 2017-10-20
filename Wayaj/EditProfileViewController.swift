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
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var aboutDescriptionView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var placesVisitedView: UIView!
    @IBOutlet weak var favoriteActivitiesView: UIView!
    @IBOutlet weak var bucketListView: UIView!
    
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
    
    let picker = UIImagePickerController()
    
    
    // Add 3 cltokenviews to bucketlist, locations traveled, fav activities
    // 3 arrays to store all values for each
    // Store arrays in userdefaults
    // 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //print(placesTokenView.placeholderText.debugDescription)
        
        
        placesVisitedView.addSubview(placesTokenView)
        favoriteActivitiesView.addSubview(activitiesTokenView)
        bucketListView.addSubview(bucketListTokenView)
        
        
       
        
        //bucketListTokenView.frame = CGRect(x: 0, y: 0, width: bucketListTokenView.frame.width, height: 80)
        
        bioTextView.delegate = self
        placesTokenView.delegate = self
        activitiesTokenView.delegate = self
        bucketListTokenView.delegate = self
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        placesTokenView.frame = CGRect(x: 0, y: 0, width: placesVisitedView.frame.width, height: placesVisitedView.frame.height)
        placesTokenView.backgroundColor = .white
        activitiesTokenView.frame = CGRect(x: 0, y: 0, width: favoriteActivitiesView.frame.width, height: favoriteActivitiesView.frame.height)
        activitiesTokenView.backgroundColor = .white
        
        bucketListTokenView.frame = CGRect(x: 0, y: 0, width: bucketListView.frame.width, height: bucketListView.frame.height)
        
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
            
            // remove items from array
            
        } else if view == activitiesTokenView {
            activities.append(token.displayText)
            
        } else {
            bucketList.append(token.displayText)
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
        UserDefaults.standard.setValue(bioTextView.text, forKey: "aboutMe")
        UserDefaults.standard.setValue(places, forKey: "placesTraveled")
        //UserDefaults.standard.setValue(activities, forKey: "favoriteActivities")
        UserDefaults.standard.setValue(bucketList, forKey: "bucketListArray")
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        UserDefaults.standard.set(imageData, forKey: "profileImage")
        UserDefaults.standard.synchronize()
        
        
    }
    
    func loadImage(){
        self.name = FacebookIdentityProfile.sharedInstance().userName!
        
        if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? Data {
            if let image = UIImage(data: profileImage) {
                self.image =  image
            }
            
        }
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

        
        
    }
    
    
    
    
    
}