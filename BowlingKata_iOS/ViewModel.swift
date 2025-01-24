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
    var stringRollScores: [String] = []
    
    private var pins: [Int] = []
    
    mutating func roll(_ scoredPins: Int) {
        if let first = pins.first {
            let rawScore = first + scoredPins
            if rawScore < 10 {
                frameScore = rawScore
                stringRollScores.append(String(scoredPins))
            } else {
                stringRollScores.append("/")
            }
        } else {
            stringRollScores.append(String(scoredPins))
        }
        pins.append(scoredPins)
    }
}
