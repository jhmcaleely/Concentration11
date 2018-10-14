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
    var lastMoveTime = Date()
    
    func cardWasFlipped(at index: Int) -> Bool {
        if !cards[index].isFaceUp {
            return true
        }
        else {
            // if the card is face up, it is a flip to keep it face up when two are face up
            if indexOfOneAndOnlyFaceUpCard == nil {
                return true
            }
        }
        return false
    }
    
    func chooseCard(at index: Int) {
        var moveDurationMs: Int?
        
        if cardWasFlipped(at: index) {
            flipCount += 1
            moveDurationMs = Int(Date().timeIntervalSince(lastMoveTime) * 1000)
            lastMoveTime = Date()
        }
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += matchBonus(moveDurationMs ?? 0)
                }
                else {
                    if cards[matchIndex].isSeen {
                        score += seenPenalty(moveDurationMs ?? 0)
                    }
                    if cards[index].isSeen {
                        score += seenPenalty(moveDurationMs ?? 0)
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
    
    let timeBands = [500, 1000, 1500]
    let matchScores = [8, 6, 4, 2]
    let seenPenalties = [-1, -2, -3, -4]
    
    func scoreInterval(_ interval: Int, _ scores: [Int]) -> Int {
        if interval < timeBands[0] {
            return scores[0]
        }
        else if interval < timeBands[1] {
            return scores[1]
        }
        else if interval < timeBands[2] {
            return scores[2]
        }
        else {
            return scores[3]
        }
    }
    
    func matchBonus(_ duration: Int) -> Int {
        return scoreInterval(duration, matchScores)
    }
    
    func seenPenalty(_ duration: Int) -> Int {
        return scoreInterval(duration, seenPenalties)
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
