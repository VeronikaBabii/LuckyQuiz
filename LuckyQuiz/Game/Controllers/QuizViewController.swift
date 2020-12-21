//
//  QuizViewController.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var quizLogic = QuizLogic()
    
    var quiz: [Question] {
        
        let quizNum = UserDefaults.standard.object(forKey: "quizNum") as? String ?? "1"
        
        switch quizNum {
        case "1":
            return Quiz.first.quiz
        case "2":
            return Quiz.second.quiz
        case "3":
            return Quiz.third.quiz
        default:
            return Quiz.first.quiz
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizLogic.checkAnswer(quiz, userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = .clear
            sender.layer.cornerRadius = 24
            sender.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            sender.layer.borderWidth = 4
            
        } else {
            sender.backgroundColor = .clear
            sender.layer.cornerRadius = 24
            sender.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            sender.layer.borderWidth = 5
        }
        
        if quizLogic.nextQuestion(quiz) {
            let scoreLbl = scoreLabel.text ?? "Score: 3"
            let score = scoreLbl.replacingOccurrences(of: "Score: ", with: "")
            UserDefaults.standard.set(score, forKey: "score")
            displayWinScreen()
        }
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        questionLabel.text = quizLogic.getQuestionName(quiz)
        
        let answers = quizLogic.getQuestionAnswers(quiz)
        firstButton.setTitle("\(answers[0])", for: .normal)
        secondButton.setTitle("\(answers[1])", for: .normal)
        thirdButton.setTitle("\(answers[2])", for: .normal)
        
        progressBar.progress = quizLogic.getProgress(quiz)
        scoreLabel.text = "Score: \(quizLogic.getScore())"
        
        setUpDesign(firstButton)
        setUpDesign(secondButton)
        setUpDesign(thirdButton)
    }
    
    func setUpDesign(_ button: UIButton) {
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(identifier: Storyboard.gameViewController) as? GameViewController
        
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
    
    func displayWinScreen() {
        let winViewController = storyboard?.instantiateViewController(identifier: Storyboard.winViewController) as? WinViewController
        
        view.window?.rootViewController = winViewController
        view.window?.makeKeyAndVisible()
    }
}
