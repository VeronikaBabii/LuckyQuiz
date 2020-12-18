//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Mark Vais on 20.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import WebKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let utils = Utils()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsLinkPreview = false
        loading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.7) {
            self.checkWhatToShow() // can only be called from here
            self.loading.stopAnimating()
        }
    }
    
    func checkWhatToShow() {
        
        if UserDefaults.standard.object(forKey: "SHOW_WEB") as? String == "true" {
            
            // show user notifications prompt here if it's a first launch
            let launch: String = UserDefaults.standard.object(forKey: "isFirstLaunch") as? String ?? "false"
            if launch == "true" {
                showPushPrompt()
            }
            
            // load url in webview
            let url = "\(UserDefaults.standard.object(forKey: "AGREEMENT_URL") ?? "https://www.google.com")"
            
            let link = URL(string: url)!
            let request = URLRequest(url: link)
            self.webView.load(request)
            
        } else if UserDefaults.standard.object(forKey: "SHOW_WEB") as? String == "false" {
            
            print("showing game")
            
            // TODO: add showing of webview for user rights acceptance (reason for webview usage)
            
            let storyboard = UIStoryboard(name: "GameScreen", bundle: nil)
            let gameViewController = storyboard.instantiateViewController(identifier: "gameVC") as? GameViewController
            self.view.window?.rootViewController = gameViewController
            self.view.window?.makeKeyAndVisible()
            
        } else {
            print("Error: SHOW_WEB or SHOW_GAME is nil!")
        }
    }
    
    func showPushPrompt() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let promptVC = storyboard.instantiateViewController(identifier: "pushPrompt")
        promptVC.modalPresentationStyle = .fullScreen
        show(promptVC, sender: self)
    }
}
