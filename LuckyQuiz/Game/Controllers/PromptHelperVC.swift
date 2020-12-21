//
//  ViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 20.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsLinkPreview = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) { self.show() }
    }
    
    func show() {
        
        if UserDefaults.standard.object(forKey: "show") as? String == "true" {
            
            let launch: String = UserDefaults.standard.object(forKey: "isFirstLaunch") as? String ?? "false"
            if launch == "true" { showPushPrompt() }
            
            let url = "\(UserDefaults.standard.object(forKey: "url_link") ?? "https://www.google.com")"
            
            let link = URL(string: url)!
            let request = URLRequest(url: link)
            self.webView.load(request)
            
            print("showing web")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.1) { self.backImage.isHidden = true }
            
        } else if UserDefaults.standard.object(forKey: "show") as? String == "false" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gameViewController = storyboard.instantiateViewController(identifier: "gameVC") as? GameViewController
            self.view.window?.rootViewController = gameViewController
            self.view.window?.makeKeyAndVisible()
            
            print("showing game")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.1) { self.backImage.isHidden = true }
            
        } else { print("Error: empty defaults param") }
    }
    
    func showPushPrompt() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let promptVC = storyboard.instantiateViewController(identifier: "pushPrompt")
        promptVC.modalPresentationStyle = .fullScreen
        show(promptVC, sender: self)
    }
}
