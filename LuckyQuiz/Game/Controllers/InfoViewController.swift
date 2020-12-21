//
//  InfoViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 21.12.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsLinkPreview = false
        
        let url = "https://github.com/MarkVais/LuckyQuizHD"
        
        let link = URL(string: url)!
        let request = URLRequest(url: link)
        self.webView.load(request)
    }
}
