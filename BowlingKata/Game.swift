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
        for (i, frame) in frames.enumerated() {
            if i > 0 {
                frame.previousFrame = frames[i - 1]
            }
            if i < frames.count - 1 {
                frame.nextFrame = frames[i + 1]
            }
        }
        rolls = Array(repeating: 0, count: 21)
        rollIndex = 0
        frameIndex = 0
        frameScoreIndex = 0
    }

    class Frame {
        var roll1: Int?
        var roll2: Int?
        var roll3: Int?
        var previousFrame: Frame?
        var nextFrame: Frame?
        var score: Int? {
            guard let localScore else {
                return nil
            }
            return localScore + previousScore
        }

        private var localScore: Int? {
            guard let bonusScore else {
                return nil
            }

            if !isStrike, roll2 == nil {
                return nil
            }

            return (roll1 ?? 0) + (roll2 ?? 0) + bonusScore
        }

        private var previousScore: Int {
            previousFrame?.score ?? 0
        }

        private var isStrike: Bool {
            roll1 == 10
        }

        private var isSpare: Bool {
            guard let roll1, let roll2 else {
                return false
            }
            return roll1 + roll2 == 10
        }

        private var nextTwoRolls: Int? {
            guard
                let nextRoll1 = nextFrame?.roll1,
                let nextRoll2 = nextFrame?.roll2 ?? nextFrame?.nextFrame?.roll1
            else {
                return nil
            }

            return nextRoll1 + nextRoll2
        }

        private var bonusScore: Int? {
            if let roll3 {
                return roll3
            }
            if isStrike {
                return nextTwoRolls
            }
            if isSpare {
                return nextFrame?.roll1
            }
            return 0
        }
    }
    
    public func roll(_ pins: Int) {
        rolls[rollIndex] = pins
        rollIndex += 1

        if frames[frameIndex].roll1 == nil {
            frames[frameIndex].roll1 = pins
            if pins == 10, frameIndex < 9 {
                frameIndex += 1
                frames[frameIndex - 1].nextFrame = frames[frameIndex]
            }
        } else if frames[frameIndex].roll2 == nil {
            frames[frameIndex].roll2 = pins
            if frameIndex < 9 {
                frameIndex += 1
            }
        } else {
            frames[frameIndex].roll3 = pins
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
