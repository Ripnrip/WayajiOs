//
//  OfferPageViewController.swift
//  Wayaj
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class OfferPageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var image:Image!
    var bookURL:URL!
    var isExpanded = false
    var selectedSection = 0
    var currentListing:Listing!
    

    override func viewWillAppear(_ animated: Bool) {
        self.imageView.image = image
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
