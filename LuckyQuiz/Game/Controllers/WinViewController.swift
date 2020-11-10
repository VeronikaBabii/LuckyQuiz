//
//  WinViewController.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
    
    @IBOutlet weak var winLabel: UILabel!
    
    //var score = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("s - \(score)")
    }
    
//    func onUserAction(data: String) {
//        let myScore = data.replacingOccurrences(of: "Score: ", with: "")
//        print("score is \(myScore)")
//        score = myScore
//        print(score)
//    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        let quizViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.quizViewController) as? QuizViewController
        view.window?.rootViewController = quizViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
    
}
