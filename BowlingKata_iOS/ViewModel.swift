//
//  ViewModel.swift
//  BowlingKata_iOS
//
//  Created by Jonathan Irving on 1/2/25.
//

import Foundation

struct ViewModel {
    let framesCount = 10
    let finalFrameIndex = 9
    var frameScore: Int? = nil
    var rollScores: [String] = []
    
    private var rolls: [Int] = []
    
    mutating func roll(_ roll: Int) {
        if let first = rolls.first {
            let frameScore = first + roll
            if frameScore < 10 {
                self.frameScore = frameScore
                rollScores.append(String(roll))
            } else {
                rollScores.append("/")
            }
        } else if roll == 10 {
            rollScores.append("X")
            rollScores.append("")
        } else {
            rollScores.append(String(roll))
        }
        rolls.append(roll)
    }
}
