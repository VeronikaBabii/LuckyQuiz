//
//  QuizLogic.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct QuizLogic2 {
    
    // casino
    let quiz1 = [
        Question(q: "Casinos was originated in", a: ["USA", "Italy", "Mexico"], c: "Italy"),
        Question(q: "What is the highest number on a roulette wheel?", a: ["18", "24", "36"], c: "36"),
        Question(q: "When was the first online casino launched?", a: ["1992", "1994", "1996"], c: "1994"),
        Question(q: "Which casino game offers you the best statistical chance of winning?", a: ["Blackjack", "Roulette", "Slot machines"], c: "Blackjack"),
        Question(q: "Which of the following is the name of a popular Japanese game of chance?", a: ["Punto Banco", "Pachinko", "Pikachu"], c: "Pachinko"),
        
        Question(q: "Which is the world’s first casino?", a: ["Casino di Venezia", "Casino de Monte Carlo", "The Golden Nugget casino"], c: "Casino di Venezia"),
        Question(q: "What is the only mathematically beatable game in a casino?", a: ["Craps", "Blackjack", "Roulette"], c: "Blackjack"),
        Question(q: "What is Punto Banco?", a: ["Spanish Blackjack", "Slot machine", "Baccarat"], c: "Baccarat"),
        Question(q: "In Baccarat, who is also known as the Croupier?", a: ["The Player On The Right", "The Underdog", "The Dealer"], c: "The Dealer"),
        Question(q: "What is a shoe in the game of baccarat?", a: ["The highest bet", "The one who loses", "Card dealing box"], c: "Card dealing box"),
        
        Question(q: "Which is the world’s largest casino?", a: ["Monte Carlo Casino", "Venetian Macau", "MGM Grand Hotel and Casino"], c: "Venetian Macau"),
        Question(q: "Which of the following popular casino games in known as the Devils game?", a: ["Blackjack", "Video Slots", "Roulette"], c: "Roulette"),
        Question(q: "Who invented the roulette wheel by mistake?", a: ["René Descartes", "Blaise Pascal", "Pierre Bardin"], c: "Blaise Pascal"),
        Question(q: "In Roulette, how many zeros are on the European Wheel?", a: ["One", "Two", "Three"], c: "One"),
        Question(q: "Which kind of slot machine has a fixed jackpot amount?", a: ["Progressive", "Low End", "Flat Top"], c: "Flat Top")
    ]
    
    var questionNumber = 0
    
    var score = 0
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == quiz1[questionNumber].correctAnswer {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getQuestionName() -> String {
        return quiz1[questionNumber].text
    }
    
    func getQuestionAnswers() -> [String] {
        return quiz1[questionNumber].answer
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(quiz1.count)
    }
    
    mutating func nextQuestion() -> Bool {
        if (questionNumber < quiz1.count - 1) {
            questionNumber += 1
            return false
        } else {
            questionNumber = 0
            score = 0
            return true
        }
    }
}
