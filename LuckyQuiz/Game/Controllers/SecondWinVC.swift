//
//  SecondWinVC.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class SecondWinVC: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScore()
    }
    
    func setScore() {
        let score = "\(UserDefaults.standard.object(forKey: "score") ?? "5")"
        lbl.text = "Great job!\nYour score is \(score)"
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        let secondQuizVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.secondQuizVC) as? SecondQuizVC
        view.window?.rootViewController = secondQuizVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
    
}
