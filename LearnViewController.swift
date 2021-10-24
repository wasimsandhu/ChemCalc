//
//  LearnViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 5/28/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import WebKit

class LearnViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webKitView: WKWebView!
    var fileName: String!
    var pageTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = pageTitle
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        webKitView.uiDelegate = self
        webKitView.navigationDelegate = self

        let url = URL(string: "http://wasimsandhu.com/chemcalc/" + fileName + ".html")
        webKitView.load(URLRequest(url: url!))
    }
}
