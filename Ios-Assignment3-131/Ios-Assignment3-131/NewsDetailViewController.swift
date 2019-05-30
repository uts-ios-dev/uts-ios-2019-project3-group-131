//
//  NewsDetailViewController.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 28/5/19.
//

import UIKit
import WebKit

class NewsDetailViewController : UIViewController {
    
    @IBOutlet var webView: WKWebView!
    var selectedFeedURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFeedURL = selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL = selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        self.view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: selectedFeedURL! as String)!))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
    }

}

