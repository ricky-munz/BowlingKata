//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

public final class Game {

    public let frames: [Frame]
    public var endGame: () -> Void = {}

    private var frameIndex: Int
    private var currentFrame: Frame { frames[frameIndex] }

    public init() {
        frames = (0..<10).map { Frame(isFinal: $0 == 9) }

        for (i, frame) in frames.enumerated() {
            if i > 0 {
                frame.previousFrame = frames[i - 1]
            }
            if i < frames.count - 1 {
                frame.nextFrame = frames[i + 1]
            }
        }

        frameIndex = 0
    }

    public class Frame {
        public var roll1: Int?
        public var roll2: Int?
        public var roll3: Int?
        public var previousFrame: Frame?
        public var nextFrame: Frame?
        public var score: Int? {
            guard let localScore else {
                return nil
            }
            return localScore + previousScore
        }

        public var isStrike: Bool {
            roll1 == 10
        }

        public var isSpare: Bool {
            guard let roll1, let roll2 else {
                return false
            }
            return roll1 + roll2 == 10
        }

        var isFinal: Bool

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

        init(isFinal: Bool) {
            self.isFinal = isFinal
        }

        func update(pins: Int) {
            if roll1 == nil {
                roll1 = pins
            } else if roll2 == nil {
                roll2 = pins
            } else {
                roll3 = pins
            }
        }
    }

    public func roll(_ pins: Int) {
        currentFrame.update(pins: pins)
        updateFrameIndex()
        evaluateGame()
    }

    private func updateFrameIndex() {
        if currentFrame.roll2 == nil, currentFrame.roll3 == nil, currentFrame.isStrike, !currentFrame.isFinal {
            frameIndex += 1
        } else if currentFrame.roll2 != nil, currentFrame.roll3 == nil, !currentFrame.isFinal {
            frameIndex += 1
        }
    }

    private func evaluateGame() {
        if currentFrame.roll3 != nil {
            endGame()
        } else if currentFrame.roll2 != nil, currentFrame.isFinal, !currentFrame.isStrike, !currentFrame.isSpare {
            endGame()
        }
    }
}
