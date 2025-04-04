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
        var isLastFrame: Bool {
            nextFrame == nil
        }
        var score: Int? {
            if isLastFrame {
                if roll1 == 10, let roll2, let roll3 {
                    return 10 + roll2 + roll3 + (previousFrame?.score ?? 0)
                }
            }
            if roll1 == 10 {
                if let nextRoll1 = nextFrame?.roll1, let nextRoll2 = nextFrame?.roll2 {
                    return 10 + nextRoll1 + nextRoll2 + (previousFrame?.score ?? 0)
                } else if let nextRoll1 = nextFrame?.roll1, let nextRoll2 = nextFrame?.nextFrame?.roll1 {
                    return 10 + nextRoll1 + nextRoll2 + (previousFrame?.score ?? 0)
                }
            }
            if
                let roll1,
                let roll2,
                roll1 + roll2 == 10,
                let nextRoll = nextFrame?.roll1
            {
                return 10 + nextRoll
            }
            
            guard
                let roll1,
                roll1 < 10,
                let roll2,
                roll1 + roll2 < 10
            else {
                return nil
            }
            return roll1 + roll2 + (previousFrame?.score ?? 0)
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
        } else if frames[frameIndex].isLastFrame, frames[frameIndex].roll2 != nil {
            frames[frameIndex].roll3 = pins
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
