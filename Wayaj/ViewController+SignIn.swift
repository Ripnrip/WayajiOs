//
//  ViewController+SignIn.swift
//  Wayaj
//
//  Created by Admin on 9/21/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognito
import AWSMobileHubHelper
import AWSFacebookSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import RealmSwift
import ReplayKit
import SwiftSpinner

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
            
            // Authenticating the User
            SyncUser.logIn(with: .facebook(token: FBSDKAccessToken.current().tokenString),
                           server: URL(string: "http://ec2-34-230-65-31.compute-1.amazonaws.com:9080")!)
            { user, error in
                if let user = user {
                    
                    print("the user is \(user)")
                    DispatchQueue.main.async {
                        SwiftSpinner.show("Loading...")
                        
                    }
                    
                    self.getFBUserInfo()
                    
                } else if let error = error {
                    // handle error
                    print("error in saving user \(error)")
                }
            }
            
        } else {
            // handle error here
        }
    }
    
    func setupRealm(){
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
                        syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://ec2-34-230-65-31.compute-1.amazonaws.com:9080/4ca6917f529505872e6260600cf0d7ae/users")!)
                    )
                    self.realm = try! Realm(configuration: configuration)
                    
                    
                    print("all the objects are \(self.realm.objects(Listing.self))")
                }
        }
    }
    
    func getFBUserInfo() {
        
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.width(414).height(255), gender, birthday"])
        request?.start(completionHandler: { (connection, object , error) in
            if error != nil {
                print("there was some error with getting the persons fb data \(String(describing: error))")
                return
            }
            //let dict = object as! Dictionary<AnyHashable, Any>
            let dict:[String:AnyObject] = object as! [String : AnyObject]
            let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
            //Download image from imageURL
            
            
            try! self.realm.write() {
                //self.realm.beginWrite()
                var number: Int = Int(arc4random())
                let u = User()
                u.name = "test"
                u.email = "taco@taco.com"
                print(dict["email"])
                u.facebook_id = dict["id"] as! String
                u.gender = "male"
                u.photo = "sampl.jpg"
                u.info = dict.description
                u.id = number
                self.realm.add(u, update: true)
            }
            
            print("the picture URL is \(imageURL)")
            print("all the data from this bogus thingy is \(dict)")
            
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
                    var profImage = UIImageJPEGRepresentation(profileImage, 1.0)
                    UserDefaults.standard.set(profImage, forKey: "profileImage")
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
