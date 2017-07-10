//
//  OfferPageViewController.swift
//  Wayaj
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Kingfisher

class OfferPageViewController: UIViewController, AACarouselDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var AACarousel: AACarousel!
    
    var titleArray = [String]()

    
    var image:Image!
    var bookURL:URL!
    var isExpanded = false
    var selectedSection = 0
    var currentListing:Listing!
    var descriptionText:String!

    override func viewWillAppear(_ animated: Bool) {
        //self.imageView.image = image
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        
        self.descriptionTextView.setContentOffset(.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        descriptionTextView.text = descriptionText
        
        //gallery
        //let pathArray = ["https://gedeongrc-my.sharepoint.com/personal/mvelardi_gedeongrc_com/Documents/Wayaj/assets/app%20and%20site%20photos/hotel-photos/L%27Auberge%20Del%20Mar-CA--/L%27Auberge%20Del%20Mar-%20Cabana%20Accommodations.jpg","https://gedeongrc-my.sharepoint.com/personal/mvelardi_gedeongrc_com/Documents/Wayaj/assets/app%20and%20site%20photos/hotel-photos/L%27Auberge%20Del%20Mar-CA--/L%27Auberge%20Del%20Mar-%20Spa.jpg","https://gedeongrc-my.sharepoint.com/personal/mvelardi_gedeongrc_com/Documents/Wayaj/assets/app%20and%20site%20photos/hotel-photos/L%27Auberge%20Del%20Mar-CA--/L%27Auberge%20Del%20MAr-%20Suite.jpg","https://gedeongrc-my.sharepoint.com/personal/mvelardi_gedeongrc_com/Documents/Wayaj/assets/app%20and%20site%20photos/hotel-photos/L%27Auberge%20Del%20Mar-CA--/L%27Auberge%20Del%20Mar.jpg"]
        let pathArray:[String] = currentListing.images!
        titleArray = [currentListing.name]
        AACarousel.delegate = self
        AACarousel.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "defaultImage")
        //optional methods
        AACarousel.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        AACarousel.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 1, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
        
    }
    //require method
    func downloadImages(_ url: String, _ index: Int) {
        
        //here is download images area
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            
            if error == nil {
                self.AACarousel.images[index] = downloadImage!
                }else{
                print("the error in downloading the image is \(error)")
            }
            
        })
    }
    
    
    @IBAction func book(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "offerWebPage") as! TripAdvisorWebViewController
        myVC.url = bookURL
        self.navigationController?.pushViewController(myVC, animated: true)
        
    }

}

extension OfferPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell\(indexPath.section+1)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        return cell!
    }
    
    
}
