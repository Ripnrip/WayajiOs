//
//  SavedViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/9/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Spring


class SavedViewController: UIViewController {
    
    var offers: [NSManagedObject] = []
    var results:[Listing] = []
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var saveBGImageView: UIImageView!
    @IBOutlet weak var saveInfoLabel: UILabel!
    @IBOutlet weak var boatImageView: SpringImageView!
    @IBOutlet weak var airplaneImageView: SpringImageView!
    
    @IBOutlet weak var airBalloonImageView: SpringImageView!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
        
        fetchData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidLayoutSubviews() {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(hex: "61C561")
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func fetchData(){
        self.results.removeAll()
        //onlyDateArr.removeAll()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Offer")
        
        do {
            let results = try context.fetch(fetchRequest)
            let  dateCreated = results as! [Offer]
            
            if results.count == 0 {
                self.tableView.isHidden = true
                saveBGImageView.isHidden = false
                saveInfoLabel.isHidden = false
                boatImageView.isHidden = false
                airplaneImageView.isHidden = false
                airBalloonImageView.isHidden = false
                self.view.backgroundColor = UIColor(hex: "2C6CD8")
            }else{
                self.tableView.isHidden = false
                saveBGImageView.isHidden = true
                saveInfoLabel.isHidden = true
                boatImageView.isHidden = true
                airplaneImageView.isHidden = true
                airBalloonImageView.isHidden = true
                self.view.backgroundColor = UIColor(hex: "EAF2F9")

            }
            
            for _datecreated in dateCreated {
                print(_datecreated.name)
                //print(_datecreated.image)
                print(_datecreated.isFavorited)
                print(_datecreated.id)
                let offer = Listing()
                offer.name = _datecreated.name!
                offer.location = _datecreated.location!
                offer.isFavorited = _datecreated.isFavorited
                offer.id = _datecreated.id!
                offer.image1 = _datecreated.imageURL!
                offer.price = _datecreated.price!
                offer.stars = Int(_datecreated.stars)
                offer.listingDescription = _datecreated.information!
                offer.overallRating = Int(_datecreated.overallRating)
                //offer.URL = _datecreated.url?
                offer.materialAndResourceScore = Int(_datecreated.materialAndResourceScore)
                offer.managementScore = Int(_datecreated.managementScore)
                offer.communityScore = Int(_datecreated.communityScore)
                offer.waterScore = Int(_datecreated.waterScore)
                offer.recycleAndWaterScore = Int(_datecreated.recycleAndWaterScore)
                offer.energyScore = Int(_datecreated.energyScore)
                offer.indoorsScore = Int(_datecreated.indoorsScore)
                let imageURL = URL(string:_datecreated.imageURL!)
                //var imageView = UIImageView().kf.setImage(with: imageURL)
                
                if offer.isFavorited == true {
                self.results.append(offer)
                }
            }
            self.tableView.reloadData()

        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! OfferTableViewCell
        cell.listingObject = results[indexPath.row]
        cell.isSaved = true
        cell.id = results[indexPath.row].id
        let imageURL = URL(string:results[indexPath.row].image1)
        cell.offerImage.kf.setImage(with: imageURL)
        
        cell.heartButton.setImage(UIImage(named:"greenHeart"), for: .normal)
        cell.nameLabel.text = results[indexPath.row].name
        cell.locationLabel.text = results[indexPath.row].location
        cell.priceLabel.text = results[indexPath.row].price
        
        var mutableString = NSMutableAttributedString(string: "Eco-Rating")
        mutableString.addAttribute(NSAttributedStringKey.font,
                                   value: UIFont.boldSystemFont(ofSize: 12),
                                   range: NSRange(location:0, length: mutableString.length)
        )
        
        
        if results[indexPath.row].overallRating >= 90 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": Excellent"))
            
            cell.scoreLabel.text = "Eco-Rating: EXCELLENT"
            //cell.scoreLabel.attributedText = combo
        } else if results[indexPath.row].overallRating >= 76  {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": Great"))
            
            cell.scoreLabel.text = "Eco-Rating: GREAT"
            //cell.scoreLabel.attributedText = combo
        } else if results[indexPath.row].overallRating >= 40 && results[indexPath.row].overallRating < 76 {
            var combo = NSMutableAttributedString()
            combo.append(mutableString)
            combo.append(NSMutableAttributedString(string: ": Good"))
            
            cell.scoreLabel.text = "Eco-Rating: GOOD"
            //cell.scoreLabel.attributedText = combo
        }
        

        
        let divideValue = CGFloat(results[indexPath.row].overallRating)/100.00
        let dynamicWidth = (cell.frame.width * divideValue) - 30
        let frame = CGRect(x: cell.greenBar.frame.origin.x, y: cell.greenBar.frame.origin.y, width:dynamicWidth , height: cell.greenBar.frame.height)
        
        
        cell.greenBar.frame = frame
        return cell//UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissKeyboard()
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = results[indexPath.row]
        
        var cell:OfferTableViewCell = tableView.cellForRow(at: indexPath) as! OfferTableViewCell
        
        var myVC2 = storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        
        myVC2.imageURL = selectedListing.image1
        myVC2.name = selectedListing.name
        myVC2.location = selectedListing.location
        myVC2.information = selectedListing.listingDescription
        myVC2.isFavorited = false
        myVC2.price = selectedListing.price
        myVC2.currentListing = selectedListing
        
        print(selectedListing.name)
        
        let divideValue = CGFloat(results[indexPath.row].overallRating)/100.00
        let dynamicWidth = myVC2.scoreBar.frame.width * divideValue
        let frame = CGRect(x: myVC2.scoreBar.frame.origin.x, y: myVC2.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC2.scoreBar.frame.height)
        //print("the green bar dynamic width is \(dynamicWidth)")
        //print("the score fraction to divide/multiply by is \(divideValue)")
        myVC2.scoreBar.frame = frame
        
        self.navigationController?.pushViewController(myVC2, animated: true)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
