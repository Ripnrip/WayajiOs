//
//  ActivitiesDetailViewController.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/13/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class ActivitiesDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var activitiesTableView: UITableView!
    
    var activities = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //activitiesTableView.dataSource = self
        //activitiesTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityDetailCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = activities[indexPath.row]
        
        return cell
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
