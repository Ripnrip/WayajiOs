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


class SavedViewController: UIViewController {
    
    var offers: [NSManagedObject] = []
    var results:[Listing] = []
    @IBOutlet var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

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
            }else{
                self.tableView.isHidden = false
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
                offer.price = String(_datecreated.price)
                offer.stars = Int(_datecreated.stars)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OfferTableViewCell
        cell.listingObject = results[indexPath.row]
        cell.isSaved = true
        cell.id = results[indexPath.row].id
        let imageURL = URL(string:results[indexPath.row].image1)
        cell.offerImage.kf.setImage(with: imageURL)
        
        cell.heartButton.setImage(UIImage(named:"greenHeart"), for: .normal)
        cell.nameLabel.text = results[indexPath.row].name
        cell.locationLabel.text = results[indexPath.row].location
        
        return cell//UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissKeyboard()
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedListing = results[indexPath.section]
        
        var cell:OfferTableViewCell = tableView.cellForRow(at: indexPath) as! OfferTableViewCell
        
        var myVC = storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        
        myVC.imageURL = selectedListing.image1
        myVC.name = selectedListing.name
        myVC.location = selectedListing.location
        myVC.information = selectedListing.listingDescription
        myVC.isFavorited = false
        myVC.price = selectedListing.price
        myVC.currentListing = selectedListing
        
        let divideValue = CGFloat(results[indexPath.section].overallRating)/100.00
        let dynamicWidth = myVC.scoreBar.frame.width * divideValue
        let frame = CGRect(x: myVC.scoreBar.frame.origin.x, y: myVC.scoreBar.frame.origin.y, width:dynamicWidth , height: myVC.scoreBar.frame.height)
        //print("the green bar dynamic width is \(dynamicWidth)")
        //print("the score fraction to divide/multiply by is \(divideValue)")
        myVC.scoreBar.frame = frame
        
        self.navigationController?.pushViewController(myVC, animated: true)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
