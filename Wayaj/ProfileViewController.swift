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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        print(UserDefaults.standard.string(forKey: "name"))
        print(UserDefaults.standard.string(forKey: "pictureURL"))
        print(UserDefaults.standard.string(forKey: "aboutMe"))
        print(UserDefaults.standard.string(forKey: "whereHaveYouTraveled"))
        print(UserDefaults.standard.string(forKey: "favoriteItems"))
        print(UserDefaults.standard.string(forKey: "bucketList"))

        if let imageURL = (UserDefaults.standard.string(forKey: "pictureURL")){
            getDataFromUrl(url: URL(string:imageURL)!, completion: { (data, response, error) in
            if error == nil {
                self.profileImage.image = UIImage(data: data!)!
            }else {
                print("there was an error getting the picure url \(error)")
            }
        })
            
        }
        
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.nameLabel.text = name
        }
    
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1029)
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
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
