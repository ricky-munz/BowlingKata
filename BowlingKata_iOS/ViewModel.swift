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
    var frameScores: [String]
    var rollScores: [String] = []
    private let game = Game()
    
    private var frameIndex = 0
    
    init() {
        frameScores = game.frames.map { frame in
            frame.score.map(String.init) ?? ""
        }
    }
    
    func roll(_ roll: Int) {
        game.roll(roll)
        
        rollScores = []
        for (index, frame) in game.frames.enumerated() {
            if index == 9 {
                if frame.isStrike {
                    rollScores.append("X")

                    if frame.roll2 == 10 {
                        rollScores.append("X")
                    } else if let roll2 = frame.roll2 {
                        rollScores.append(String(roll2))
                    }
                    if frame.roll3 == 10 {
                        rollScores.append("X")
                    } else if let roll2 = frame.roll2,
                              let roll3 = frame.roll3,
                              roll2 + roll3 == 10 {
                        rollScores.append("/")
                    } else if let roll3 = frame.roll3 {
                        rollScores.append(String(roll3))
                    }
                    continue
                }
                if let roll1 = frame.roll1 {
                    rollScores.append(String(roll1))
                }
                if frame.isSpare {
                    rollScores.append("/")
                    if let roll3 = frame.roll3 {
                        if roll3 == 10 {
                            rollScores.append("X")
                        } else {
                            rollScores.append(String(roll3))
                        }
                    }
                    continue
                }
                if let roll2 = frame.roll2 {
                    rollScores.append(String(roll2))
                }
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
}
