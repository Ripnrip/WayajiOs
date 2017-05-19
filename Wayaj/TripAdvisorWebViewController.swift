//
//  TripAdvisorWebViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/18/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit

class TripAdvisorWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.tripadvisor.com/VacationRentalReview-g3135627-d5987900-Magical_Lava_Temple_on_Big_Island_Hawaii-Kalapana_Island_of_Hawaii_Hawaii.html")
        let urlRequest = URLRequest(url: url!)
        self.webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
