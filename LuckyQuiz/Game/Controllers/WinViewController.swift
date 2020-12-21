//
//  WinViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
    
    @IBOutlet weak var winLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScore()
    }
    
    func setScore() {
        let score = "\(UserDefaults.standard.object(forKey: "score") ?? "5")"
        winLabel.text = "Great job!\nYour score is \(score)"
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        let quizViewController = storyboard?.instantiateViewController(identifier: Storyboard.quizViewController) as? QuizViewController
        view.window?.rootViewController = quizViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(identifier: Storyboard.gameViewController) as? GameViewController
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
}
