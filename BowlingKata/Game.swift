//
//  Game.swift
//  BowlingKata
//
//  Created by Ricky Munz on 11/22/24.
//

import Foundation

public final class Game {

    public let frames: [Frame]
    private let endGame: () -> Void

    private var currentFrame: Frame

    public init(endGame: @escaping () -> Void = {}) {
        frames = (0..<10).map { _ in Frame() }

        for (i, frame) in frames.enumerated() {
            if i > 0 {
                frame.previousFrame = frames[i - 1]
            }
            if i < frames.count - 1 {
                frame.nextFrame = frames[i + 1]
            }
        }

        currentFrame = frames[0]
        self.endGame = endGame
    }

    public func roll(_ pins: Int) {
        currentFrame.update(pins: pins)
        setCurrentFrame()
        evaluateGame()
    }

    private func setCurrentFrame() {
        if currentFrame.isComplete, let nextFrame = currentFrame.nextFrame {
            currentFrame = nextFrame
        }
    }

    private func evaluateGame() {
        if currentFrame.isFinal, currentFrame.isComplete {
            endGame()
        }
    }
}
