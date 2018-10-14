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
    
    static let gameThemes: [Theme] = [Theme(name: "Halloween", emoji: ["🎃", "👻", "🙀", "😈", "🦇", "😱", "🍭", "🍬", "🍎"], backgroundColour: UIColor.black, cardBackgroundColour: UIColor.orange),
                               Theme(name: "Sports" , emoji: ["⚽️", "🏀", "🏈", "⚾️", "🎱", "🏸", "🏓", "🎾", "🏐"], backgroundColour: UIColor.white, cardBackgroundColour: UIColor.blue),
                               Theme(name: "Faces", emoji: ["😀", "😊", "😇", "😂", "🤣", "🤓", "😎", "🤩", "😘"], backgroundColour: UIColor.purple, cardBackgroundColour: UIColor.yellow),
                               Theme(name: "Food", emoji: ["🍏", "🍐", "🍊", "🍇", "🍓", "🍆", "🥑", "🥦", "🥐"], backgroundColour: UIColor.green, cardBackgroundColour: UIColor.white),
                               Theme(name: "Office", emoji: ["📱", "💻", "💿", "⏰", "🔌", "🎙", "📽", "📟", "🖨"], backgroundColour: UIColor.gray, cardBackgroundColour: UIColor.black),
                               Theme(name: "Flags", emoji: ["🏁", "🚩", "🏳️‍🌈", "🇧🇪", "🇧🇷", "🇨🇰", "🇧🇮", "🇬🇪", "🇩🇪"], backgroundColour: UIColor.red, cardBackgroundColour: UIColor.green)]
    
    static func randomTheme() -> Theme {
        return gameThemes[Int(arc4random_uniform(UInt32(gameThemes.count)))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    lazy var theme = ViewController.randomTheme()

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        theme = ViewController.randomTheme()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) :  theme.cardBackgroundColour
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        self.view.backgroundColor = theme.backgroundColour
        scoreLabel.textColor = theme.cardBackgroundColour
        flipCountLabel.textColor = theme.cardBackgroundColour
        newGameButton.setTitleColor(theme.cardBackgroundColour, for: UIControl.State.normal)
    }
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, theme.emoji.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(theme.emoji.count)))
            emoji[card.identifier] = theme.emoji.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

