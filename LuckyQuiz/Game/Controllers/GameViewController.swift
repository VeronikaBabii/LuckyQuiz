//
//  GameViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 29.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBAction func quiz1Tapped(_ sender: UIButton) { UserDefaults.standard.set("1", forKey: "quizNum") }
    @IBAction func quiz2Tapped(_ sender: UIButton) { UserDefaults.standard.set("2", forKey: "quizNum") }
    @IBAction func quiz3Tapped(_ sender: UIButton) { UserDefaults.standard.set("3", forKey: "quizNum") }
}
