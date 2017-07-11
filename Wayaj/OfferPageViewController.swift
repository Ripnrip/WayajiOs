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
        
        let pathArray:[String] = currentListing.images!
        titleArray = [currentListing.name]
        AACarousel.delegate = self
        AACarousel.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 1.0, defaultImage:
            "defaultImage")
        //handleFirstImageView()
        //optional methods
        AACarousel.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 6, pageIndicatorColor: UIColor.lightGray, describedTitleColor: UIColor.white, layerColor: UIColor.gray)
        AACarousel.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)

        
    }
    //require method
    func downloadImages(_ url: String, _ index: Int) {
        AACarousel.images[0] = currentListing.image

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
    
    func handleFirstImageView() {
        let url = URL(string: currentListing.images![0])
        var pictures = AACarousel.images as! NSArray
        var firstImage = pictures[0] as! UIImage

        
        //firstImage.kf.setImage(with: url)
        
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: (url?.absoluteString)!)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            
            if error == nil {
                self.AACarousel.images[0] = downloadImage!
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
