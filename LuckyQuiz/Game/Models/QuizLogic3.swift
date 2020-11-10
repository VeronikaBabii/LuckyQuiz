//
//  QuizLogic.swift
//  WebViewDemo
//
//  Created by Mark Vais on 30.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct QuizLogic3 {
    
    // gaming
    let quiz1 = [
        Question(q: "Which color is the most eye-catching?", a: ["Red", "Yellow", "Green"], c: "Yellow"),
        Question(q: "What was the first commercially successful video game?", a: ["Pong", "Super Mario Bros", "Donkey Kong Country"], c: "Pong"),
        Question(q: "What is the best-selling video game of all time?", a: ["FIFA 18", "Minecraft", "Call of Duty: Modern Warfare 3"], c: "Minecraft"),
        Question(q: "What inspired games maker Satoshi Tajiri to create Pokémon?", a: ["A dream", "Butterflies", "An old TV show"], c: "Butterflies"),
        Question(q: "What is a ‘frag’?", a: ["A cheat code", "Enemy", "The number of killed things"], c: "The number of things you have ‘killed’ in a game"),
        
        Question(q: "What is the fictional language in The Sims?", a: ["Simlish", "Simian", "Simali"], c: "Simlish"),
        Question(q: "How many Playstation 4 consoles have been sold?", a: ["50 million", "80 million", "over 100 million"], c: "over 100 million"),
        Question(q: "Which was the first game to sell more than 10 million copies?", a: ["Super Mario Bros.", "World of Warcraft", "GTA"], c: "Super Mario Bros."),
        Question(q: "Which of the following games has not been turned into a movie?", a: ["Silent Hill", "Far Cry", "Quake"], c: "Quake"),
        Question(q: "What is the best selling console of all time?", a: ["Nintendo Wii", "Playstation 2", "Game Boy"], c: "Playstation 2"),
        
        Question(q: "When was the first Call of Duty game released?", a: ["2002", "2003", "2004"], c: "2003"),
        Question(q: "In which game do players compete in a futuristic version of soccer with cars?", a: ["Rocket League", "Dropzone", "Stardew Valley"], c: "Rocket League"),
        Question(q: "When was the first Nintendo console released?", a: ["1963", "1983", "2003"], c: "1983"),
        Question(q: "What was Sonic the Hedgehog's originally called?", a: ["Tiggy Winkle", "Punk Rat", "Mr. Needlemouse"], c: "Mr. Needlemouse"),
        Question(q: "What is the biggest selling game for Xbox One?", a: ["Halo 5: Guardians", "Grand Theft Auto V", "Call of Duty: Infinite Warfare"], c: "Grand Theft Auto V")
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
