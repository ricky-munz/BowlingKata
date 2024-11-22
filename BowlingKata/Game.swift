//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

final class Game {
    private var theScore = 0

    func roll(_ pins: Int) {
        theScore += pins
    }

    func score() -> Int {
        theScore
    }
}
