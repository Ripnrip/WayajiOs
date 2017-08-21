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

class OfferDetailViewController: UIViewController {

    @IBOutlet var ratingsTableView: UITableView!
    
    @IBOutlet var baseImageView: UIImageView!
    @IBOutlet var barView: UIView!
    @IBOutlet var informationTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var infoLabel: UITextView!
    
    var imageURL:String = ""
    var name = ""
    var location = ""
    var information = ""
    var price = "$$$"
    var isFavorited = false
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: imageURL)
        baseImageView.kf.setImage(with: url)
        nameLabel.text = name
        locationLabel.text = location
        priceLabel.text = price
        informationTextView.text = information
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func expandInfoView(_ sender: Any) {
        
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func materialsInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        txtLabel.text = "Purchasing and Products \n\n These are the factors considered in this rating: \n -Have a sustainable purchasing plan \n -Number of products manufactured locally \n -Number of products with sustainable supply chain \n \nSustainable practices promote the use of locally manufactured products and to purchase materials that have a sustainably sourced supply chain"
        
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func managementInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        txtLabel.text = "Management \n\n These are the factors considered in this rating: \n \n -Follow all health, safety, and labor laws \n -Advertise all sustainability programs \n -Have a sustainability plan \n -Policy against exploitation and discrimination \n -Have a sustainability contact person \n -Educate employees on sustainability \n -Request/act on guest feedback for sustainability \n \n Socially responsible practices provide a safe, healthy, and non-discriminatory work place for all genders, races, religions and social classes."
        txtLabel.isEditable = false
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func communityInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        txtLabel.text = "Community \n\n These are the factors considered in this rating: \n -Hire local people (within 50 miles) \n -Hire locals to management \n -Community involvement \n -Proximity to public or green transportation \n -Support local issues and sustainable development \n -Travel incentives for employees \n \n Sustainable practices drive tourism to areas that support the local community, including its people and environment."
        let popover = Popover()
        txtLabel.isEditable = false
        
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func waterInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 250))
        txtLabel.text = "Water \n\n These are the factors considered in this rating: \n -Meter overall water consumption \n -Towel/linen reuse programs \n -Plan to reduce water consumption \n -Capture rain water \n -Reuse water \n -Water consumption \n -Treat wastewater before it reenters the water supply \n \nSustainable practices reduce water consumption, reuse water when possible, use natural sources of water, and practice wastewater treatment."
        txtLabel.isEditable = false
        
        let popover = Popover()
        popover.show(txtLabel, point: startPoint)
    }
    
    @IBAction func recycleInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 250))
        txtLabel.text = "Waste \n\n These are the factors considered in this rating: \n -Monitor waste and offer recycling for all materials possible \n -Have a waste management and reduction plan \n -Total waste diverted from landfills and incinerators \n \n Sustainable practices promote water conservation and monitor waste management."
        let popover = Popover()
        txtLabel.isEditable = false
        
        popover.show(txtLabel, point: startPoint)
    }
    
    @IBAction func energyInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        txtLabel.text = "Energy \n\n These are the factors considered in this rating: \n -Monitoring energy consumption \n -Guest programs to reduce energy \n -Energy efficient lighting \n -Have an energy reduction plan \n -Energy efficient appliances \n -Use renewable energy (and/or purchase carbon offsets) \n \nSustainable practices reduce energy consumption as much as possible and use clean energy for the remaining electrical load"
        let popover = Popover()
        txtLabel.isEditable = false
        
        popover.show(txtLabel, point: startPoint)
        
    }
    
    @IBAction func indoorsInfo(_ sender: Any) {
        let startPoint = barView.center
        let txtLabel = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        txtLabel.text = "Indoor Environment \n\n These are the factors considered in this rating: \n -Indoor smoking is not allowed indoors \n -Use green cleaning products and practices \n -Each room has lighting controls \n -Each room has a source of daylight \n -Have indoor environment plan \n \nSustainable practices promote the quality of the indoor environment resulting in high guest satisfaction, health, and well-being."
        let popover = Popover()
        txtLabel.isEditable = false
        
        popover.show(txtLabel, point: startPoint)
        
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
        let identifier = "cell\(indexPath.row)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
