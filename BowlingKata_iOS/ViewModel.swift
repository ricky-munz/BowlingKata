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
    var rollScores: [Int] = []
    
    mutating func roll(_ pins: Int) {
        if !rollScores.isEmpty {
            frameScore = 0
        }
        
        rollScores.append(pins)
    }
}
