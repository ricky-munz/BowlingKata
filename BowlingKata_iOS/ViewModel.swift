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
        
        let lastTwoRolls = rolls.suffix(2).reduce(0, +)

        if roll == 10 {
            rollScores.append("X")
            rollScores.append("")
        } else if rolls.count > 1, lastTwoRolls == 10 {
            rollScores.append("/")
        } else {
            rollScores.append(String(roll))
        }
        
        if rolls.count.isMultiple(of: 2), lastTwoRolls != 10 {
            frameScores[frameIndex] = game.frames[frameIndex].score
            frameIndex += 1
        }

        if rolls.count > 2, rolls.prefix(2).reduce(0, +) == 10 {
            frameScores[frameIndex] = game.frames[frameIndex].score
            frameIndex += 1
        }
    }
}
