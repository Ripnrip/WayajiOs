//  ViewController.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Eureka
import CoreLocation
import AWSCore
import AWSCognito
import AWSMobileHubHelper
import AWSFacebookSignIn
import FBSDKCoreKit
import FBSDKLoginKit
//MARK: HomeViewController
import SwiftSpinner



//MARK: Custom Cells Example

class CustomCellsController : FormViewController, UIImagePickerControllerDelegate {
    
    var imageURL:String = ""
    var name:String = ""
    var email:String = ""
    var gender:String = ""
    var image:UIImage = UIImage()
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadImage(){
        self.name = FacebookIdentityProfile.sharedInstance().userName!
        
        if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? NSData {
            let image = NSKeyedUnarchiver.unarchiveObject(with: profileImage as Data) as! UIImage
            self.image =  image
            
        }
    }
    func loadSettings() {
        
        let syncClient: AWSCognito = AWSCognito.default()
        let userSettings: AWSCognitoDataset = syncClient.openOrCreateDataset("user_settings")
        
        userSettings.synchronize().continueWith { (task: AWSTask<AnyObject>) -> Any? in
            if let error = task.error as? NSError {
                print("loadSettings error: \(error)")
                return nil
            }
            self.imageURL = userSettings.string(forKey: "pictureURL")
            self.name = userSettings.string(forKey: "name")
            self.email = "TACOS@tacos.com"//userSettings.string(forKey: "email")
            self.gender = userSettings.string(forKey: "gender")
            
            if let profileImage = UserDefaults.standard.value(forKey: "profileImage") as? NSData {
                let image = NSKeyedUnarchiver.unarchiveObject(with: profileImage as Data) as! UIImage
                self.image =  image
            }


            print("the values retrieved are \(self.imageURL) and \(self.name) \(self.email)")
            return 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //get user info 
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FormViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
        var shownOnce = false
        loadImage()
        loadSettings()

        self.tableView?.backgroundColor = UIColor(red: 38/255, green: 201/255, blue: 82/255, alpha: 1.0)
        
        var aboutMe = UserDefaults.standard.value(forKey: "aboutMe") as? String
        var whereHaveYouTraveled = UserDefaults.standard.value(forKey: "whereHaveYouTraveled") as? String
        var favoriteItems = UserDefaults.standard.value(forKey: "favoriteItems") as? String
        var bucketList = UserDefaults.standard.value(forKey: "bucketList") as? String
        
        
        
        
        form +++
            Section() {
                var header = HeaderFooterView<EurekaLogoViewNib>(.nibFile(name: "EurekaSectionHeader", bundle: nil))
                header.onSetupView = { (view, section) -> () in
                    //if already done once
                    
                    if shownOnce == false {
                    view.imageView.alpha = 0;
                    UIView.animate(withDuration: 2.0, animations: { [weak view] in
                        view?.imageView.alpha = 1
                    })
                    view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
                    UIView.animate(withDuration: 1.0, animations: { [weak view] in
                        view?.layer.transform = CATransform3DIdentity
                    })
                        shownOnce = true
                    }
                }
                $0.header = header
            }
            <<< ImageRow(){
                $0.title = "Profile Image"
                $0.value = self.image
                $0.imageURL = URL(string:self.imageURL)
                
            }

            
//            +++ Section("Basic Information")
            
//            <<< NameRow() {
//                $0.title =  "Name:"
//                $0.value = self.name
//            }
//            <<< EmailRow() {
//                $0.title = "Email:"
//                $0.value = self.email
//            }
//            <<< SegmentedRow<String>(){
//                $0.options = ["Male", "Female", "Other"]
//                $0.value = self.gender
//            }
//          

            
            +++ Section("Tell Us About Yourself")

                    
            <<< TextAreaRow(){
                $0.value = aboutMe
                $0.placeholder = "I like long walks on the beach, and eating tacos all day"
                }.onChange({ (tRow) in
                    aboutMe = tRow.value!
                    print(aboutMe)
                })
            <<< TextRow(){
                $0.value = whereHaveYouTraveled
                $0.placeholder = "Where have you traveled?"
            }.onChange({ (tRow) in
                whereHaveYouTraveled = tRow.value!
            })
            
            <<< TextRow(){
                $0.value = favoriteItems
                $0.placeholder = "What are some of your favorite activities?"
                }.onChange({ (tRow) in
                    favoriteItems = tRow.value!
                })
            <<< TextRow(){
                $0.value = bucketList
                $0.placeholder = "What are some items on your bucket list?"
                }.onChange({ (tRow) in
                    bucketList = tRow.value!
                })
            +++ Section(){
            $0.tag = "Submit"
            }
            <<< ButtonRow("Done") { (row: ButtonRow) -> Void in
                row.title = row.tag
                //row.presentationMode = .segueName(segueName: "goHome", onDismiss: nil)
                
                
        }.onCellSelection({ (btn, row) in
            UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial2")
            UserDefaults.standard.setValue(aboutMe, forKey: "aboutMe")
            UserDefaults.standard.setValue(whereHaveYouTraveled, forKey: "whereHaveYouTraveled")
            UserDefaults.standard.setValue(favoriteItems, forKey: "favoriteItems")
            UserDefaults.standard.setValue(bucketList, forKey: "bucketList")
            UserDefaults.standard.synchronize()
            self.goHome()
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    func goHome() {
        DispatchQueue.main.async{
        //self.performSegue(withIdentifier: "goToHome", sender: self)
        self.dismiss(animated: true, completion: nil)
        }

    }

    
    /// what app will do when user choose & complete the selection image :
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            //self.imgView.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
           // self.imgView.image = orginalImage
        }
        else { print ("error") }
        
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


class EurekaLogoViewNib: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class EurekaLogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        imageView.autoresizingMask = .flexibleWidth
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
