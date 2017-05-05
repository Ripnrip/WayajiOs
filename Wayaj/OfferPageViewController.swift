//
//  OfferPageViewController.swift
//  Wayaj
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class OfferPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var isExpanded = false
    var selectedSection = 0
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }


}
extension OfferPageViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell\(indexPath.section + 1)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        print("the cell is \(identifier)")
        return cell!//UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isExpanded == false {
            if indexPath.section == 0 {
                return 256
            } else {
                return 49
            }
        } else {
            if selectedSection == indexPath.section {
            if selectedSection == 0 {
                return 256
            }
            if selectedSection == 1 {
                return 347
            } else if selectedSection == 2 {
                return 647
            } else if selectedSection == 3 {
                return 647
            } else if selectedSection == 4 {
                return 767
            } else if selectedSection == 5 {
                return 600
            }
                
                
            }
        }
            return UITableViewAutomaticDimension
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        
        if isExpanded == false {
            isExpanded = true
            selectedSection = indexPath.section
        } else {
            isExpanded = false
            selectedSection = indexPath.section
        }
        
        tableView.reloadData()
        print("the isExpanded value is \(isExpanded) and the selectedSection is \(indexPath.section)")
        
    }
    
}
