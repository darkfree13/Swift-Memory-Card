//
//  CardData.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 2/04/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation

class DeckData { // Class to handle the Greek God Data
    func getAllCards () -> [GameCard]{ //Function that returns the God Data
        
        var deck: [GameCard] = [GameCard]() // Creates an empty array of GreekGods
        for i in 0..<8 {
            let dataCard = GameCard(_value: i, _status: "i") // Creates one card
            deck.append(dataCard) // add one card to the array deck
            let dataCard2 = GameCard(_value: i, _status: "i")
            deck.append(dataCard2)
            deck = deck.sorted { _,_ in arc4random_uniform(2) == 0} // Barajamos la baraja
            
        }
        deck = deck.sorted { _,_ in arc4random_uniform(2) == 0}
        
        return deck // Returns the array of gods
    }
}
