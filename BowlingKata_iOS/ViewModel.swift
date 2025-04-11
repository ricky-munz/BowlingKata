//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation
import BowlingKata

struct ViewModel {
    var frameScores: [Int?]
    var rollScores: [String] = []
    private let game = Game()
    
    private var rolls: [Int] = []
    private var frameIndex = 0
    
    init() {
        frameScores = game.frames.map { $0.score }
    }
    
    mutating func roll(_ roll: Int) {
        rolls.append(roll)
        game.roll(roll)
        
        rollScores = []
        game.frames.forEach { frame in
            if let roll1 = frame.roll1 {
                switch roll1 {
                    case 10:
                    rollScores.append("X")
                    rollScores.append("")
                default:
                    rollScores.append(String(roll1))
                }
            }
            if let roll1 = frame.roll1, let roll2 = frame.roll2 {
                if roll1 + roll2 == 10 {
                    rollScores.append("/")
                } else {
                    rollScores.append(String(roll2))
                }
            }
            if let roll3 = frame.roll3 {
                rollScores.append(String(roll3))
            }
        }
        
        frameScores = game.frames.map { $0.score }
    }
}
