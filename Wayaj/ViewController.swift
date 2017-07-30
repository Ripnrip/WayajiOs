//
//  ViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/1/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import paper_onboarding
import Spring
import AWSCore
import AWSCognito
import AWSMobileHubHelper
import AWSFacebookSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftSpinner


class ViewController: UIViewController {
    @IBOutlet weak var onboarding: PaperOnboarding!
    @IBOutlet var skipButton: SpringButton!
    
    var onboardingView = PaperOnboarding()
    @IBOutlet weak var btn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        btn.isHidden = true
        onboarding.isHidden = true
        let shouldShowTutorial:Bool = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial1"))
        if ( shouldShowTutorial == false ) {
        self.navigationController?.isNavigationBarHidden = true
        self.skipButton.isHidden = true
        onboardingView = PaperOnboarding(itemsCount: 3)
        onboardingView.dataSource = self
        onboardingView.delegate = self
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingView)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
            
        }
        skipButton.frame = CGRect(x: 251, y: self.view.frame.size.height-70, width: 98, height: 30)
        onboardingView.addSubview(skipButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Set Facebook login permission scopes before the user logs in. Additional permissions can added here if desired.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile", "email", "user_friends"])
        let facebookButton = AWSFacebookSignInButton(frame: CGRect(x: 30, y: self.view.frame.height-100, width: self.view.frame.width - 60 , height: 50))
        // Set button style large to show the text "Continue with Facebook"
        // use the label property named "providerText" to format the text or change the content
        facebookButton.buttonStyle = .large
        
        // Set the button sign in delegate to handle feedback from sign in attempt
        facebookButton.delegate = self
        self.view.addSubview(facebookButton)
    }
    
    
    @IBAction func skip(_ sender: Any) {
        onboardingView.removeFromSuperview()
        onboarding.removeFromSuperview()
        // remove constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.removeConstraint(constraint)
        }
        UserDefaults.standard.setValue(true, forKey: "userViewedInitialTutorial1")
        print("\(UserDefaults.standard.value(forKey: "userViewedInitialTutorial1")!)")
        
    }

    @IBAction func signIn(_ sender: Any) {

    }
    
    
    
    



}
extension ViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        //    skipButton.isHidden = index == 2 ? false : true
        if index == 3 {
            print("last Index")
            self.skipButton.isHidden = false
            self.skipButton.animate()
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {

    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
}


// MARK: AWSFacebookSignIn
extension ViewController: AWSSignInDelegate {
    
    func onLogin(signInProvider: AWSSignInProvider,
                 result: Any?,
                 authState: AWSIdentityManagerAuthState,
                 error: Error?) {
        
        if error != nil {
            print("Error with login, returning")
            return
        }
        
        if let result = result {
            // handle success here
            print("the fb login result is \(result) and the auth state is \(authState.rawValue) and the error is \(String(describing: error)) and the loaded data from FB is \(FacebookIdentityProfile.sharedInstance().userName) and the other info  is \(FacebookIdentityProfile.sharedInstance().getAttributeForKey("email"))")
            getFBUserInfo()
        } else {
            // handle error here
        }
    }
    
    func getFBUserInfo() {
        SwiftSpinner.show("Loading...")

        let syncClient: AWSCognito = AWSCognito.default()
        var userSettings: AWSCognitoDataset = syncClient.openOrCreateDataset("user_settings")
        
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.width(500).height(400), gender, birthday"])
        request?.start(completionHandler: { (connection, object , error) in
            if error != nil {
                print("there was some error with getting the persons fb data \(String(describing: error))")
                return
            }
            //let dict = object as! Dictionary<AnyHashable, Any>
            let dict:[String:AnyObject] = object as! [String : AnyObject]
            let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                //Download image from imageURL
            
            print("the picture URL is \(imageURL)")
            print("all the data from this bogus thingy is \(dict)")
            userSettings.setString(dict.description, forKey: "profileInfo")
            userSettings.setString(dict["id"] as! String, forKey: "facebookID")
            userSettings.setString(dict["name"] as! String, forKey: "name")
            //userSettings.setString(dict["email"] as! String, forKey: "email")
            userSettings.setString(dict["gender"] as! String, forKey: "gender")
            userSettings.setString(imageURL! , forKey: "pictureURL")
            userSettings.synchronize()

            
            //NSUSERDEFAULTS
            UserDefaults.standard.setValue(dict.description, forKey: "profileInfo")
            UserDefaults.standard.setValue(dict["id"] as! String, forKey: "facebookID")
            UserDefaults.standard.setValue(dict["name"] as! String, forKey: "name")
            //UserDefaults.standard.setValue(dict["email"] as! String, forKey: "email")
            UserDefaults.standard.setValue(dict["gender"] as! String, forKey: "gender")
            UserDefaults.standard.setValue(imageURL!, forKey: "pictureURL")
            
            
            var profileImage = UIImage()
            
            self.getDataFromUrl(url: URL(string:imageURL!)!, completion: { (data, response, error) in
                if error == nil {
                    let imageDownload = UIImage(data: data!)
                    profileImage = imageDownload!
                    
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: imageDownload!), forKey: "profileImage")
                    UserDefaults.standard.synchronize()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                    self.present(controller, animated: true, completion: nil)
                }else{
                    print("the error in getting the datafromURL is \(error) with response \(response)")
                    
                }
            })
            
            

            
            
        })
    
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}




// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {

        
        let titleFont = UIFont(name: "Nunito-Bold", size: 34.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        
        let item1 = (imageName: "intro-icon1", title: "Welcome to Wayaj", description: "The first app for sustainable and socially responsible vacations.", iconName: "", color: UIColor(red:97/255, green:198/255, blue:97/255, alpha:1.00), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        
        let item2 = (imageName: "intro-icon4", title: "Discover", description: "The Wayaj app lets you explore destinations...", iconName: "", color: UIColor(red:97/255, green:198/255, blue:97/255, alpha:1.00), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        let item3 = (imageName: "intro-icon3", title: "Book", description: "...and book eco-friendly trips.", iconName: "", color: UIColor(red:97/255, green:198/255, blue:97/255, alpha:1.00), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        
        let item4 = (imageName: "intro-icon5" , title: "Enjoy!", description: "Choose the perfect hotel for you by learning about the sustainability of your destination based on a detailed eco-rating system.", iconName: "", color: UIColor(red:97/255, green:198/255, blue:97/255, alpha:1.00), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        
        switch index {
        case 0:
            return item1
            break
        case 1:
            return item2
            break
        case 2:
            return item3
            break
        case 3:
            return item4
            break
        default:
            return item1
        }
        
        return item1

    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {

        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
    
    
}

