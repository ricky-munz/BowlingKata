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
    var rollScores: [String] = []
    var frameScores: [String] = Array(repeating: "", count: 10)
    var pins: String = ""
    var isGameCompleted: Bool = false
    var isResetPresented: Bool = false

    private var frameIndex = 0
    
    @ObservationIgnored
    private lazy var game = makeNewGame()

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
        rollScores = []
        isGameCompleted = false
        frameScores = Array(repeating: "", count: 10)
        game = makeNewGame()
    }
    
    private func makeNewGame() -> Game {
        Game(endGame: {
            self.isGameCompleted = true
        })
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
