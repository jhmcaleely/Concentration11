//
//  Card.swift
//  Concentration 11
//
//  Created by John McAleely on 13/10/2018.
//  Copyright © 2018 John McAleely. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var isSeen = false
    var identifier: Int
    
    static var identiferFactory = 0
    
    static func getUniqueIdentifer() -> Int {
        identiferFactory += 1
        return identiferFactory
    }
    
    init() {
        identifier = Card.getUniqueIdentifer()
    }
}
