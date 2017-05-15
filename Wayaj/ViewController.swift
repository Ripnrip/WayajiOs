//
//  ViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/1/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import paper_onboarding

class ViewController: UIViewController {
    @IBOutlet weak var onboarding: PaperOnboarding!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    


}
extension ViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        //    skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        let item1 = (imageName: "BIG_IMAGE1", title: "Title", description: "Description text", iconName: "IconName1", color: UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), titleColor: UIColor.blue, descriptionColor: UIColor.green, titleFont: titleFont, descriptionFont: descriptionFont)
        
        let item2 = (imageName: "BIG_IMAGE1", title: "Title", description: "Description text", iconName: "IconName1", color: UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), titleColor: UIColor.blue, descriptionColor: UIColor.green, titleFont: titleFont, descriptionFont: descriptionFont)
        
        let item3 = (imageName: "BIG_IMAGE1", title: "Title", description: "Description text", iconName: "IconName1", color: UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), titleColor: UIColor.blue, descriptionColor: UIColor.green, titleFont: titleFont, descriptionFont: descriptionFont)
        
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
        default:
            return item1
        }
        
        return item1
        //        return [
        //            ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), descriptionFont, titleFont, descriptionFont),
        //            ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), descriptionFont, titleFont, descriptionFont),
        //            ("BIG_IMAGE1", "Title", "Description text", "IconName1", "BackgroundColor", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), descriptionFont, titleFont, descriptionFont)
        //            ][index]
        ////        return [
        
        //            (Asset.hotels.image, "Hotels", "All hotels and hostels are sorted by hospitality rating", Asset.key.image, UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
        //            (Asset.banks.image, "Banks", "We carefully verify all banks before add them into the app", Asset.wallet.image, UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
        //            (Asset.stores.image, "Stores", "All local stores are categorized for your convenience", Asset.shoppingCart.image, UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
        //            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
}

