//
//  ThirdWinVC.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class ThirdWinVC: UIViewController {
    
    @IBOutlet weak var winLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScore()
    }
    
    func setScore() {
        let score = "\(UserDefaults.standard.object(forKey: "score") ?? "5")"
        winLbl.text = "Great job!\nYour score is \(score)"
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        let thirdQuizVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.thirdQuizVC) as? ThirdQuizVC
        view.window?.rootViewController = thirdQuizVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
    
}
