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
    
    mutating func roll(_ roll: Int) {
        rolls.append(roll)
        
        if roll == 10 {
            rollScores.append("X")
            rollScores.append("")
        } else if rolls.count > 1 && rolls[rolls.count - 1] + rolls[rolls.count - 2] == 10 {
            rollScores.append("/")
        } else {
            rollScores.append(String(roll))
        }

        if rolls.count % 2 == 0 && rolls[rolls.count - 2] + rolls[rolls.count - 1] != 10 {
            let frameScore = rolls[rolls.count - 2] + rolls[rolls.count - 1]
            frameScores[rolls.count / 2 - 1] = frameScore
        }
    }
}
