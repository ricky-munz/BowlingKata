//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation
import BowlingKata

struct ViewModel {
    var frameScores: [String]
    var rollScores: [String] = []
    private let game = Game()
    
    private var frameIndex = 0
    
    init() {
        frameScores = game.frames.map { frame in
            frame.score.map(String.init) ?? ""
        }
    }
    
    mutating func roll(_ roll: Int) {
        game.roll(roll)
        
        rollScores = []
        for frame in game.frames {
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
            if let roll3 = frame.roll3 {
                rollScores.append(String(roll3))
            }
        }
        
        frameScores = game.frames.map { frame in
            frame.score.map(String.init) ?? ""
        }
    }
}
