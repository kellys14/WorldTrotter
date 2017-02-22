//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Sean Kelly on 2/13/17.
//  Copyright © 2017 Sean Melnick Kelly. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView()
    {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        print("WebViewController loaded it's view with the site: \(myURL)")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
/*        let myURL = URL(string: "www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)*/
    }
}

