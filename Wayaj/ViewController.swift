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
import RealmSwift
import ReplayKit

class ViewController: UIViewController {
    @IBOutlet weak var onboarding: PaperOnboarding!
    @IBOutlet var skipButton: SpringButton!
    
    var realm: Realm!

    var onboardingView = PaperOnboarding()
    @IBOutlet weak var btn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        btn.isHidden = true
        onboardingView.isHidden = true
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
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile", "email", "user_friends"])
        let facebookButton = AWSFacebookSignInButton(frame: CGRect(x: 30, y: self.view.frame.height-150, width: self.view.frame.width - 60 , height: 50))
        let termsButton = UIButton(frame: CGRect(x: 30, y: self.view.frame.height-100, width: self.view.frame.width - 60 , height: 30))
            termsButton.setTitle("By signing in, you agree to the terms of use", for: .normal)
            termsButton.titleLabel?.font = UIFont(name:"Times New Roman", size: 17)
            termsButton.titleLabel?.textColor = UIColor.white
            termsButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)


        // Set button style large to show the text "Continue with Facebook"
        // use the label property named "providerText" to format the text or change the content
        facebookButton.buttonStyle = .large
        
        // Set the button sign in delegate to handle feedback from sign in attempt
        facebookButton.delegate = self
        self.view.addSubview(facebookButton)
        self.view.addSubview(termsButton)

        setupRealm()

    }
    @objc func pressed(sender: UIButton!) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "offerWebPage") as! TripAdvisorWebViewController
        guard let url = URL(string:"https://s3.amazonaws.com/gedeon-1/Terms+of+Use+final+(1).pdf") else {return}
        myVC.url = url
        self.navigationController?.pushViewController(myVC, animated: true)
        
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

}

