//
//  OfferPageViewController.swift
//  Wayaj
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Kingfisher
import Popover

class OfferPageViewController: UIViewController, AACarouselDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var AACarousel: AACarousel!
    //@IBOutlet var collectionOfButtons: Array<UIButton>?
    
//    @IBOutlet weak var materialsButton: UIButton!
//    @IBOutlet weak var managementButton: UIButton!
//    @IBOutlet weak var communityButton: UIButton!
//    @IBOutlet weak var waterButton: UIButton!
//    @IBOutlet weak var recycleButton: UIButton!
//    @IBOutlet weak var energyButton: UIButton!
//    @IBOutlet weak var indoorsButton: UIButton!
    
    
    
    

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
    
    @IBAction func materialsInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "MATERIALS \n*The property purchases local sustainable products and has a sustainable purchasing plan, which includes current and future plans to buy local and sustainable products.\n\n**The top 2 most frequently purchased products are manufactured within 500 miles of the hotel. At least one of the top 5 must have a sustainable supply chain certification. All previous requirements are met.\n\n***The top 3 most frequently purchased products are manufactured within 500 miles of the hotel. At least two of the top 5 must have a sustainable supply chain. All previous requirements are met.\n\n****The top 5 most frequently purchased products are manufactured within 500 miles of the hotel. At least three of the top 5 must have a sustainable supply chain. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func managementInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "MANAGEMENT \n *The property follows all health, safety, and labor laws for guests and employees. It pays livable and profitable wage to all employees. Policies against exploitation and discrimination against any people are in place. \n\n**All sustainability programs are clearly marked, accessible, and advertised for guests and employees. The property has a sustainability plan and sustainability contact person. All previous requirements are met.\n\n***The property educates employees on sustainability on water, waste, energy, cleaning, food services, etc. All previous requirements are met.\n\n****The hotel asks for guest feedback concerning sustainability practices and has a plan for corrective action, if not already pursuing such action. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func communityInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "COMMUNITY RATINGS \n*The property hires local people (within 50 miles). Impacts on \nsurrounding community are minimal, if any. Located within half of a mile of public or green \ntransportation (Bike program, bus stop, low/no emitting vehicles, etc.) – not required if \nlocated in isolated area. \n\n **Some locals are in management positions. Basic programs in the community or onsite for cultural/community activities are present. Property provides onsite transportation options. All requirements for previous level are met. \n \n ***Contributions are made in community and onsite to improve community, educate on local issues, and promote sustainable development. All requirements for previous levels are met. \n\n ****Property offers to employees incentives such as travel subsidies, green vehicle purchasing, carpooling, and other ways to reduce traffic and pollution. All requirements for previous levels are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func waterInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "WATER \n*Total water consumption is 10% below the standard. Overall water consumption is metered on a monthly basis. The property has program to allow guests to reuse towels and skip housekeeping service.\n\n**Total water consumption is 20% below the standard. has plan to lower indoor and outdoor water consumption. Rooms are equipped with low flow and low flush toilets, sinks, and showers. All previous requirements are met.\n\n***Total water consumption is 30% below the standard. Wastewater is treated on site or is sent to a facility to be treated before getting discharged. All previous requirements are met.\n\n****Total water consumption is 40% below the standard. Rain water is captured and used onsite and/or water is reused on site. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
    }
    
    @IBAction func recycleInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "RECYCLE \n*The property monitors all applicable waste totals from trash, recyclables, hazardous waste, and compost. In addition, recycling is offered for all guests for plastic, paper, metal, and glass.\n\n**The property diverts at least 10% of all waste from landfills and incinerators. A waste management and reduction plan is also in place. All previous requirements are met.\n\n***The property collects e-waste and hazardous waste and implements a donation/upcycling program. 25% of all waste is diverted from landfills and incinerators. All previous requirements are met.\n\n****The property has a composting program. 50% of waste is diverted from landfills and incinerators. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
    }
    
    @IBAction func energyInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "ENERGY \n*The property monitors all energy on a monthly basis. It has programs that allow guests to cut down on energy consumption such as towel and linen reuse.\n\n**The property uses energy efficient LED lighting and energy efficient appliances. It also has a plan to lower energy consumption. All previous requirements are met.\n\n***The property uses renewable energy and/or renewable energy credits for 5% or more of all energy consumption. All previous requirements are met.\n\n****The property uses renewable energy and/or renewable energy credits for 10% of energy consumption. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func indoorsInfo(_ sender: Any) {
        let startPoint = AACarousel.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        txtLabel.text = "INDOOR ENVIRONMENT \n*Indoor smoking is not allowed in any areas. Outdoor smoking is allowed in designated areas.\n\n**The property uses green cleaning practices and products. A pest management plan is in place, and each guest room has temperature and lighting controls.\n\n***The hotel requests guest feedback on areas for improving indoor quality. Each guest room and guest area has a source of daylight and outdoor views. All previous requirements are met.\n\n****The property has an indoor environmental plan. All previous requirements are met."
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
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

extension OfferPageViewController {
    
    
}
