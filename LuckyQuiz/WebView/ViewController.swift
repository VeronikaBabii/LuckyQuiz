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
import OneSignal

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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.checkWhatToShow() // can only be called from here
            self.loading.stopAnimating()
        }
    }
    
    func checkWhatToShow() {
        
        if UserDefaults.standard.object(forKey: "SHOW_WEB") as! String == "true" {
            
            // show user notifications prompt here if it's a first launch
            showPushPrompt()
            
            // load url in webview
            var url = "\(UserDefaults.standard.object(forKey: "AGREEMENT_URL") ?? "")"
            
            if url == "" { // placeholder in webview while link are not formed from cloak
                url = "https://www.google.com"
            }
            
            let link = URL(string: url)!
            let request = URLRequest(url: link)
            self.webView.load(request)
            
            //for deposits
            //makeRequest() 
            
        } else if UserDefaults.standard.object(forKey: "SHOW_WEB") as! String == "false" {
            
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
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted OneSignal notifications - \(accepted)")
        })
    }
    
//    func makeRequest() {
//        timer.invalidate()
//
//        let bundleId = Bundle.main.bundleIdentifier
//        let hash = UserDefaults.standard.object(forKey: "UNIQUE_ID")
//        let url = URL(string: "https://integr-testing.site/apps/\(bundleId!)/?hash=\(hash!)&app_id=\(bundleId!)")!
//        print("\(url)")
//
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return } // unwrap data
//
//            let requestStatus = String(data: data, encoding: .utf8)!
//            print("request status - \(requestStatus)")
//
//            // get dep value from the request output
//            let STATUS = requestStatus.components(separatedBy: ",")[1].replacingOccurrences(of: "\"", with: "").dropLast().components(separatedBy: ":")[1]
//            print(STATUS)
//
//            //let STATUS = "true" // for testing
//
//            if STATUS == "true" {
//                print("status is true \n")
//
//                // send fb purchase event
//                AppEvents.logPurchase(1.0, currency: "USD")
//
//            } else if STATUS == "false" {
//
//                print("status is false \n")
//
//                DispatchQueue.main.async {
//                    self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.oneMinuteLater), userInfo: nil, repeats: true)
//                }
//
//            } else { print("Error sending dep checker request") }
//        }
//        task.resume()
//    }
//
//    @objc func oneMinuteLater() {
//        print("One minute passed")
//        makeRequest()
//    }
    
}
