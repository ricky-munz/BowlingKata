//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

public final class Game {
    private var rolls: [Int]
    private var currentRoll: Int
    
    public init() {
        rolls = [Int](repeating: 0, count: 21)
        currentRoll = 0
    }
    
    public func roll(_ pins: Int) {
        rolls[currentRoll] = pins
        currentRoll += 1
    }

    public func score() -> Int {
        var score = 0
        var roll = 0
        for _ in 1...10 {
            if isStrike(roll) {
                score += 10 + strikeBonus(roll)
                roll += 1
            } else if isSpare(roll) {
                score += 10 + spareBonus(roll)
                roll += 2
            } else {
                score += sumOfBallsInFrame(roll)
                roll += 2
            }
        }
        return score
    }
    
    private func isSpare(_ roll: Int) -> Bool {
        rolls[roll] + rolls[roll + 1] == 10
    }
    
    private func isStrike(_ roll: Int) -> Bool {
        return rolls[roll] == 10
    }
        
    private func strikeBonus(_ roll: Int) -> Int {
        rolls[roll + 1] + rolls[roll + 2]
    }
    
    private func spareBonus(_ roll: Int) -> Int {
        rolls[roll + 2]
    }
    
    private func sumOfBallsInFrame(_ roll: Int) -> Int {
        rolls[roll] + rolls[roll + 1]
    }
}
