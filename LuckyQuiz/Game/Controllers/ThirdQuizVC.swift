//
//  ThirdQuizVC.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit

class ThirdQuizVC: UIViewController {
    
    var quizLogic = QuizLogic3()
    
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
        let userGotItRight = quizLogic.checkAnswer(userAnswer)
        
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
        
        if quizLogic.nextQuestion() {
            let scoreLbl = scoreLabel.text ?? "Score: 3"
            let score = scoreLbl.replacingOccurrences(of: "Score: ", with: "")
            print(score)
            UserDefaults.standard.set(score, forKey: "score")
            displayWinScreen()
        }
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        questionLabel.text = quizLogic.getQuestionName()
        
        let answers = quizLogic.getQuestionAnswers()
        firstButton.setTitle("\(answers[0])", for: .normal)
        secondButton.setTitle("\(answers[1])", for: .normal)
        thirdButton.setTitle("\(answers[2])", for: .normal)
        
        progressBar.progress = quizLogic.getProgress()
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
        let gameViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
    
    func displayWinScreen() {
        let thirdWinVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.thirdWinVC) as? ThirdWinVC
        
        view.window?.rootViewController = thirdWinVC
        view.window?.makeKeyAndVisible()
    }
}
