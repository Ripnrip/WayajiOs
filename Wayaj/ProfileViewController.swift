//
//  ProfileViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/8/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

   // @IBOutlet weak var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1029)
        
    }
    
    @IBAction func openSettings(_ sender: Any) {
        
    }

}

//extension ProfileViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = "cell\(indexPath.section + 1)"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
//        print("the cell is \(identifier)")
//        return cell!//UITableViewCell()
//    }
//    
//}
