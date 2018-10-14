//
//  Concentration.swift
//  Concentration 11
//
//  Created by John McAleely on 13/10/2018.
//  Copyright © 2018 John McAleely. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    var score = 0
    var flipCount = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isFaceUp {
            flipCount += 1
        }
        else {
            // if the card is face up, it is a flip to keep it face up when two are face up
            if indexOfOneAndOnlyFaceUpCard == nil {
                flipCount += 1
            }
        }
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                else {
                    if cards[matchIndex].isSeen {
                        score -= 1
                    }
                    if cards[index].isSeen {
                        score -= 1
                    }
                }
                cards[index].isSeen = true
                cards[matchIndex].isSeen = true
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            }
            else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                
            }
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        var cardsToUse = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cardsToUse += [card, card]
        }
        
        for _ in 1...cardsToUse.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cardsToUse.count)))
            cards += [cardsToUse.remove(at: randomIndex)]
        }
    }
}
