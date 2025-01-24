//
//  BowlingKata_iOSTests.swift
//  BowlingKata_iOSTests
//
//  Created by Ricky Munz on 12/12/24.
//

import Testing
@testable import BowlingKata_iOS

struct BowlingKata_iOSTests {
    
    @Test func viewModel_onInit_hasTenFrames() {
        let sut = ViewModel()
        
        #expect(sut.framesCount == 10)
    }
    
    @Test func viewModel_onInit_finalFrameIndexIsNine() {
        let sut = ViewModel()
        
        #expect(sut.finalFrameIndex == 9)
    }

    @Test(arguments: [
        (0, "0"),
        (1, "1"),
        (9, "9")
    ])
    func viewModel_rollOnce_rollScoreMatchesInput(pins: Int, displayPins: String) {
        var sut = ViewModel()

        sut.roll(pins)

        #expect(sut.frameScore == nil)
        #expect(sut.stringRollScores == [displayPins])
    }

    @Test(arguments: [
        (0, 0, "0", "0", 0),
        (0, 1, "0", "1", 1),
        (1, 0, "1", "0", 1),
        (1, 1, "1", "1", 2),
        (8, 1, "8", "1", 9),
    ])
    func viewModel_rollTwice_frameScoreIsSum(firstPins: Int, secondPins: Int, displayFirstPins: String, displaySecondPins: String, score: Int) {
        var sut = ViewModel()
        
        sut.roll(firstPins)
        sut.roll(secondPins)

        #expect(sut.frameScore == score)
        #expect(sut.stringRollScores == [displayFirstPins, displaySecondPins])
    }
    
    @Test
    func viewModel_rollSpare_frameScoreIsNil() {
        var sut = ViewModel()
        
        sut.roll(9)
        sut.roll(1)
        
        #expect(sut.frameScore == nil)
        #expect(sut.stringRollScores == ["9", "/"])
    }
    
    @Test
    func viewModel_rollStrike_frameScoreIsNil() {
        var sut = ViewModel()
        
        sut.roll(10)
        
        #expect(sut.frameScore == nil)
        #expect(sut.stringRollScores == ["X", ""])
    }
}
