//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

final class Game {
    private var rolls = [Int](repeating: 0, count: 21)
    private var currentRoll = 0

    func roll(_ pins: Int) {
        rolls[currentRoll] = pins
        currentRoll += 1
    }

    func score() -> Int {
        var score = 0
        var roll = 0
        for _ in 1...10 {
            if isSpare(roll) {
                score += 10 + rolls[roll + 2]
            } else {
                score += rolls[roll] + rolls[roll + 1]
            }
            roll += 2
        }
        return score
    }
    
    private func isSpare(_ roll: Int) -> Bool {
        rolls[roll] + rolls[roll + 1] == 10
    }
}
