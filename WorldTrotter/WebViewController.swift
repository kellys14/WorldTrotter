//
//  WKWebView.swift
//  WorldTrotter
//
//  Created by Sean Melnick Kelly on 2/13/17.
//  Copyright © 2017 Sean Melnick Kelly. All rights reserved.
//  WebKit View Controller

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
    
    

/*    @IBOutlet weak var WebView: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIWebViewDelegate = self
        
        if let url = URL(string: "www.bignerdranch.com") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    } */

