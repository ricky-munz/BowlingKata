//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation
import BowlingKata

struct ViewModel {
    var frameScores: [Int?] = Array(repeating: nil, count: 10)
    var rollScores: [String] = []
    private let game = Game()

    private var rolls: [Int] = []
    private var frameIndex = 0

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
            frameScores[frameIndex] = game.score()
            frameIndex += 1
        }
    }
}
