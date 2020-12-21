//
//  Quiz.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 19.12.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

enum Quiz {
    case first
    case second
    case third
    
    var quiz: [Question] {
        switch self {
        case .first:
            return Quizes().quiz1
        case .second:
            return Quizes().quiz2
        case .third:
            return Quizes().quiz3
        }
    }
}

struct Quizes {
    
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
    
    let quiz2 = [
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
    
    let quiz3 = [
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
}
