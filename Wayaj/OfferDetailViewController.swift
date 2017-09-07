//
//  OfferDetailViewController.swift
//  Wayaj
//
//  Created by Admin on 8/21/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Kingfisher
import Popover

enum RatingType {
    case Material
    case Management
    case Community
    case Water
    case Recycle
    case Energy
    case Indoors
}

class OfferDetailViewController: UIViewController, AACarouselDelegate {

    var type = RatingType.self
    @IBOutlet var ratingsTableView: UITableView!
    
    @IBOutlet var baseImageView: UIImageView!
    @IBOutlet var barView: UIView!
    @IBOutlet var informationTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var infoLabel: UITextView!
    @IBOutlet var scoreBar: UIView!
    
    @IBOutlet var expandButton: UIButton!
    @IBOutlet var ecoRatingLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bookButton: UIButton!
    
    @IBOutlet var gallery: AACarousel!
    
    var currentListing:Listing?
    
    var imageURL:String = ""
    var name = ""
    var location = ""
    var information = ""
    var price = "$$$"
    var isFavorited = false
    
    var types:[RatingType] = [.Material,.Management,.Community,.Water,.Recycle,.Energy,.Indoors]
    var popUpStrings:[String] = ["Purchasing and Products \n\n These are the factors considered in this rating: \n -Have a sustainable purchasing plan \n -Number of products manufactured locally \n -Number of products with sustainable supply chain \n \nSustainable practices promote the use of locally manufactured products and to purchase materials that have a sustainably sourced supply chain","Management \n\n These are the factors considered in this rating: \n \n -Follow all health, safety, and labor laws \n -Advertise all sustainability programs \n -Have a sustainability plan \n -Policy against exploitation and discrimination \n -Have a sustainability contact person \n -Educate employees on sustainability \n -Request/act on guest feedback for sustainability \n \n Socially responsible practices provide a safe, healthy, and non-discriminatory work place for all genders, races, religions and social classes.","Community \n\n These are the factors considered in this rating: \n -Hire local people (within 50 miles) \n -Hire locals to management \n -Community involvement \n -Proximity to public or green transportation \n -Support local issues and sustainable development \n -Travel incentives for employees \n \n Sustainable practices drive tourism to areas that support the local community, including its people and environment.","Water \n\n These are the factors considered in this rating: \n -Meter overall water consumption \n -Towel/linen reuse programs \n -Plan to reduce water consumption \n -Capture rain water \n -Reuse water \n -Water consumption \n -Treat wastewater before it reenters the water supply \n \nSustainable practices reduce water consumption, reuse water when possible, use natural sources of water, and practice wastewater treatment.","Waste \n\n These are the factors considered in this rating: \n -Monitor waste and offer recycling for all materials possible \n -Have a waste management and reduction plan \n -Total waste diverted from landfills and incinerators \n \n Sustainable practices promote water conservation and monitor waste management.","Energy \n\n These are the factors considered in this rating: \n -Monitoring energy consumption \n -Guest programs to reduce energy \n -Energy efficient lighting \n -Have an energy reduction plan \n -Energy efficient appliances \n -Use renewable energy (and/or purchase carbon offsets) \n \nSustainable practices reduce energy consumption as much as possible and use clean energy for the remaining electrical load","Indoor Environment \n\n These are the factors considered in this rating: \n -Indoor smoking is not allowed indoors \n -Use green cleaning products and practices \n -Each room has lighting controls \n -Each room has a source of daylight \n -Have indoor environment plan \n \nSustainable practices promote the quality of the indoor environment resulting in high guest satisfaction, health, and well-being."]
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: imageURL)
        baseImageView.kf.setImage(with: url)
        nameLabel.text = name
        locationLabel.text = location
        priceLabel.text = price
        informationTextView.text = information
        
        self.navigationController?.isNavigationBarHidden = false
        
        guard let listing = currentListing else {return}
        let pathArray:[String] = [listing.image1,listing.image2,listing.image3]
        gallery.frame = baseImageView.frame
        gallery.delegate = self
        gallery.setCarouselData(paths: pathArray,  describedTitle: [listing.name], isAutoScroll: true, timer: 1.5, defaultImage:
            "defaultImage")
        //optional methods
        gallery.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 6, pageIndicatorColor: UIColor.lightGray, describedTitleColor: UIColor.white, layerColor: UIColor.gray)
        gallery.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        self.view.addSubview(gallery)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1150)
 
    }

    //require method
    func downloadImages(_ url: String, _ index: Int) {
        
        //here is download images area
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            
            if error == nil {
                self.gallery.images[index] = downloadImage!
            }else{
                print("the error in downloading the image is \(error)")
            }
            
        })
    }

    
    @IBAction func expandInfoView(_ sender: Any) {
        
        let x = informationTextView.frame.origin.x
        let y = informationTextView.frame.origin.y
        let width = informationTextView.frame.size.width
        let height = informationTextView.frame.size.height
        informationTextView.frame = CGRect(x: x, y: y, width: width, height: height+100)
        expandButton.isHidden = true
        expandButton.frame.origin.y = expandButton.frame.origin.y + 100
        ecoRatingLabel.frame.origin.y = ecoRatingLabel.frame.origin.y + 100
        ratingsTableView.frame.origin.y = ratingsTableView.frame.origin.y + 100
        bookButton.frame.origin.y = bookButton.frame.origin.y + 100
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func book(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "offerWebPage") as! TripAdvisorWebViewController
        guard let url = URL(string:(currentListing?.URL)!) else {return}
        myVC.url = url
        self.navigationController?.pushViewController(myVC, animated: true)
        
    }


}

extension OfferDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell0"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RatingScoreTableViewCell
        cell.type = types[indexPath.row]
        cell.popUpString = popUpStrings[indexPath.row]
        
        switch (cell.type!) {
        
        case RatingType.Material:
            cell.nameLabel.text = "Material & Resources"
            guard let score = currentListing?.materialAndResourceScore else {break}
            cell.percentLabel.text = String(score) + "%"
            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
        case RatingType.Management:
            cell.nameLabel.text = "Management"
            guard let score = currentListing?.managementScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
        case RatingType.Community:
            cell.nameLabel.text = "Community"
            guard let score = currentListing?.communityScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
        case RatingType.Water:
            cell.nameLabel.text = "Water"
            guard let score = currentListing?.waterScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
        case RatingType.Recycle:
            cell.nameLabel.text = "Recycle"
            guard let score = currentListing?.recycleAndWaterScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
            
        case RatingType.Energy:
            cell.nameLabel.text = "Energy"
            guard let score = currentListing?.energyScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
            
        case RatingType.Indoors:
            cell.nameLabel.text = "Indoors"
            guard let score = currentListing?.indoorsScore else {break}
            cell.percentLabel.text = String(score) + "%"

            let divideValue = CGFloat(score)/100.00
            let dynamicWidth = cell.scoreBar.frame.width * divideValue
            let frame = CGRect(x: cell.scoreBar.frame.origin.x, y: cell.scoreBar.frame.origin.y, width:dynamicWidth , height: cell.scoreBar.frame.height)
            cell.scoreBar.frame = frame
            break
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
}
