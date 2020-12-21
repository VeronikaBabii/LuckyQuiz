//
//  PushPromptViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 18.10.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import OneSignal

class PushPromptViewController: UIViewController {

    // on allow notif button click - show prompt
    @IBAction func allowNotif(_ sender: UIButton) {
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted OneSignal notifications - \(accepted)")
            self.dismiss(animated: true)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
