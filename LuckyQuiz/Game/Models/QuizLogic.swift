//
//  QuizLogic.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct QuizLogic {
    
    var questionNumber = 0
    var score = 0
    
    mutating func checkAnswer(_ quiz: [Question], _ userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].correctAnswer {
            score += 1
            return true
        } else { return false }
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getQuestionName(_ quiz: [Question]) -> String {
        return quiz[questionNumber].text
    }
    
    func getQuestionAnswers(_ quiz: [Question]) -> [String] {
        return quiz[questionNumber].answer
    }
    
    func getProgress(_ quiz: [Question]) -> Float {
        return Float(questionNumber) / Float(quiz.count)
    }
    
    mutating func nextQuestion(_ quiz: [Question]) -> Bool {
        if (questionNumber < quiz.count - 1) {
            questionNumber += 1
            return false
        } else {
            questionNumber = 0
            score = 0
            return true
        }
    }
}
