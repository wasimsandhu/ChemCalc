//
//  LearnViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 5/28/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!
    var webpage: String!
    var barTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = barTitle

        // Load web view
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(webView)
        webView.delegate = self
        loadWebView(page: webpage)
    }
    
    func loadWebView(page: String) {
        let myProjectBundle: Bundle = Bundle.main
        let filePath: String = myProjectBundle.path(forResource: page, ofType: "html")!
        let myURL = URL(string: filePath)
        let urlRequest: URLRequest = URLRequest(url: myURL!)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

    }
}
