//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation
import BowlingKata

@Observable
class ViewModel {
    var frameScores: [String]
    var rollScores: [String] = []
    var isGameCompleted: Bool = false

    private var game: Game
    private var frameIndex = 0
    
    init() {
        let newGame = Game()
        
        frameScores = newGame.frames.map { frame in
            frame.score.map(String.init) ?? ""
        }
        
        game = newGame
        
        game.endGame = {
            self.isGameCompleted = true
        }
    }
    
    func roll(_ roll: Int) {
        game.roll(roll)
        
        rollScores = []
        for (index, frame) in game.frames.enumerated() {
            if index == 9 {
                scoreFinal(frame: frame)
                continue
            }

            if frame.isStrike {
                rollScores.append("X")
                rollScores.append("")
                continue
            }
            if let roll1 = frame.roll1 {
                rollScores.append(String(roll1))
            }
            if frame.isSpare {
                rollScores.append("/")
                continue
            }
            if let roll2 = frame.roll2 {
                rollScores.append(String(roll2))
            }
        }
        
        frameScores = game.frames.map { frame in
            frame.score.map(String.init) ?? ""
        }
    }
    
    func reset() {
        frameScores = Array(repeating: "", count: 10)
        rollScores = []
        isGameCompleted = false
        game = Game()
        game.endGame = {
            self.isGameCompleted = true
        }
    }

    private func scoreFinal(frame: Game.Frame) {
        guard let roll1 = frame.roll1 else { return }

        if roll1 == 10 {
            rollScores.append("X")
        } else {
            rollScores.append(String(roll1))
        }

        guard let roll2 = frame.roll2 else { return }

        if roll2 == 10 {
            rollScores.append("X")
        } else if roll1 + roll2 == 10 {
            rollScores.append("/")
        } else {
            rollScores.append(String(roll2))
        }

        guard let roll3 = frame.roll3 else {
            rollScores.append("")
            return
        }

        if roll3 == 10 {
            rollScores.append("X")
        } else if roll2 + roll3 == 10 {
            rollScores.append("/")
        } else {
            rollScores.append(String(roll3))
        }
    }
}
