//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation

struct ViewModel {
    var frameScores: [Int?] = Array(repeating: nil, count: 10)
    var rollScores: [String] = []

    private var rolls: [Int] = []
    private var frameIndex = 0

    mutating func roll(_ roll: Int) {
        rolls.append(roll)

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
            let lastScore = frameIndex - 1 >= 0 ? frameScores[frameIndex - 1] ?? 0 : 0
            frameScores[frameIndex] = lastScore + lastTwoRolls
            frameIndex += 1
        }
    }
}
