//
//  TripAdvisorWebViewController.swift
//  Wayaj
//
//  Created by Gurinder Singh on 5/18/17.
//  Copyright © 2017 GRC. All rights reserved.

import UIKit

class TripAdvisorWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var url:URL!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bookURL = url else {
          return
        }
        let urlRequest = URLRequest(url: bookURL)
        self.webView.loadRequest(urlRequest)
    }

}
