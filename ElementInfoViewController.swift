//
//  ElementInfoViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/9/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import WebKit

class ElementInfoViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    var url: URL?
    var element: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = element
        
        webView.loadRequest(URLRequest(url: url!))
        
        let scrollPoint = CGPoint(x: 0, y: -400)
        webView.scrollView.setContentOffset(scrollPoint, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
