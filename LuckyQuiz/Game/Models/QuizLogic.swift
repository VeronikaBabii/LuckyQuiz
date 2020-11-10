//
//  QuizLogic.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct QuizLogic {
    
    // gambling
    let quiz1 = [
        Question(q: "The average age of gambler is", a: ["27", "35", "45"], c: "45"),
        Question(q: "Slots first appeared in", a: ["1860s", "1880s", "1900s"], c: "1880s"),
        Question(q: "The longest poker game lasted over", a: ["Two weeks", "One year", "Eight years"], c: "Eight years"),
        Question(q: "What percentage of the overall annual gaming profits do slot machines bring in?", a: ["40%", "60%", "80%"], c: "60%"),
        Question(q: "Where in the United States did poker originate?", a: ["Las Vegas", "New Orleans", "New York"], c: "New Orleans"),
        
        Question(q: "What is a Dime? ", a: ["You are betting $1,000", "You are betting $100", "You are betting $10"], c: "You are betting $1,000"),
        Question(q: "Lotto games and dominoes appeared in China as early as when?", a: ["The 8th century", "The 10th century", "The 15th century"], c: "The 10th century"),
        Question(q: "What is the most popular U.S. card game associated with gambling?", a: ["Poker", "Joker", "Blackjack"], c: "Poker"),
        Question(q: "One of the most widespread forms of gambling involves betting on what?", a: ["Online games", "Sports", "Horse or greyhound racing"], c: "Horse or greyhound racing"),
        Question(q: "In bingo, what number is referred to as Key of the door?", a: ["10", "21", "31"], c: "21"),
        
        Question(q: "In sports betting, who is considered unlikely to win?", a: ["The Rookie", "The Longshot", "The Favorite"], c: "The Longshot"),
        Question(q: "What is a split bet in Roulette?", a: ["Betting On One Number", "Betting On Two Numbers", "Betting On Three Numbers"], c: "Betting On Two Numbers"),
        Question(q: "In Blackjack, what is the card that is face-up for all the players to see?", a: ["Up Card", "The Wild Card", "Face Card"], c: "Up Card"),
        Question(q: "What is the Hole Card in Blackjack?", a: ["Dealer's Up Card", "The Joker", "Dealer's Face Down Card"], c: "Dealer's Face Down Card"),
        Question(q: "In Roulette, what is betting the ball will land on a black pocket?", a: ["White Bet", "Black Bet", "Red Bet"], c: "Black Bet"),
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
