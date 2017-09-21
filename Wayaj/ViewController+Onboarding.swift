//
//  ViewController+Onboarding.swift
//  Wayaj
//
//  Created by Admin on 9/21/17.
//  Copyright © 2017 GRC. All rights reserved.
//

// MARK: PaperOnboardingDataSource

import paper_onboarding
import Foundation

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

