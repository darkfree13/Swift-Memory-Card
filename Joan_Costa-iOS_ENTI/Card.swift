//
//  Card.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 1/04/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation

class GameCard { //Creates the class GameCard
    var value: Int
    var status: Character // i= init, g= girada, m= match
    init(_value: Int, _status: Character){ // Way to init the class GameCard
        value = _value
        status = _status
    }
}
