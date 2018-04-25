//
//  Player.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 1/04/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation

class GamePlayer { //Creates the class GamePlayer
    var Name: String
    var Score: Int
    var ID: String
    init(_Name: String, _Score: Int, _ID: String){ // Way to init the class GameCard
        Name = _Name
        Score = _Score
        ID = _ID
    }
}
