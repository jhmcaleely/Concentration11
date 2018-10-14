//
//  ViewController.swift
//  Concentration 11
//
//  Created by John McAleely on 07/10/2018.
//  Copyright © 2018 John McAleely. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    let emojiThemes: [String:[String]] = [ "Halloween": ["🎃", "👻", "🙀", "😈", "🦇", "😱", "🍭", "🍬", "🍎"],
                                           "Sports":    ["⚽️", "🏀", "🏈", "⚾️", "🎱", "🏸", "🏓", "🎾", "🏐"],
                                           "Faces":     ["😀", "😊", "😇", "😂", "🤣", "🤓", "😎", "🤩", "😘"],
                                           "Food":      ["🍏", "🍐", "🍊", "🍇", "🍓", "🍆", "🥑", "🥦", "🥐"],
                                           "Office":    ["📱", "💻", "💿", "⏰", "🔌", "🎙", "📽", "📟", "🖨"],
                                           "Flags":     ["🏁", "🚩", "🏳️‍🌈", "🇧🇪", "🇧🇷", "🇨🇰", "🇧🇮", "🇬🇪", "🇩🇪"]]
    
    func randomTheme() -> [String] {
        let themes = Array(emojiThemes.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(themes.count)))
        return emojiThemes[themes[randomIndex]]!
    }
    
    lazy var emojiChoices = randomTheme()

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCount = 0
        emojiChoices = randomTheme()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else {
            print("card not in CardButtons")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

