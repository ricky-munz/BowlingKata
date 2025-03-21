//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

public final class Game {
    var frameScores: [Int?]

    private var rolls: [Int]
    private var rollIndex: Int

    private var frameIndex: Int
    private var frameScoreIndex: Int

    let frames: [Frame]

    public init() {
        frameScores = Array(repeating: nil, count: 10)
        frames = (0..<10).map { _ in Frame() }
        rolls = Array(repeating: 0, count: 21)
        rollIndex = 0
        frameIndex = 0
        frameScoreIndex = 0
    }

    class Frame {
        var roll1: Int?
        var roll2: Int?
        var score: Int? {
            guard let score = roll1 else { return nil }
            return score + (roll2 ?? 0)
        }
    }
    
    public func roll(_ pins: Int) {
        rolls[rollIndex] = pins
        rollIndex += 1

        if frames[frameIndex].roll1 == nil {
            frames[frameIndex].roll1 = pins
            if pins == 10, frameIndex < 9 {
                frameIndex += 1
            }
        } else {
            frames[frameIndex].roll2 = pins
            if frameIndex < 9 {
                frameIndex += 1
            }
        }

        if rollIndex == 3 {
            if isSpare(rollIndex - 3) {
                frameScores[frameScoreIndex] = 10 + pins
                frameScoreIndex += 1
            }
            if isStrike(rollIndex - 3) {
                frameScores[frameScoreIndex] = 10 + strikeBonus(rollIndex - 3)
                frameScoreIndex += 1
                frameScores[frameScoreIndex] = score()
                frameScoreIndex += 1
            }
        }

        if rollIndex.isMultiple(of: 2) {
            if !isSpare(rollIndex - 2), !isStrike(rollIndex - 2) {
                frameScores[frameScoreIndex] = score()
                frameScoreIndex += 1
            }
        }

        if frameScoreIndex == 9 {
            frameScores[frameScoreIndex] = score()
        }
    }

    @discardableResult
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
