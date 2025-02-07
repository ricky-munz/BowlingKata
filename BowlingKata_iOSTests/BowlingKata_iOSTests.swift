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
        
        #expect(sut.frameScores.count == 10)
    }

    @Test(arguments: [
        (0, "0"),
        (1, "1"),
        (9, "9")
    ])
    func viewModel_rollOnce_rollScoreMatchesInput(roll: Int, score: String) {
        var sut = ViewModel()

        sut.roll(roll)

        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == [score])
    }

    @Test(arguments: [
        (0, 0, "0", "0", 0),
        (0, 1, "0", "1", 1),
        (1, 0, "1", "0", 1),
        (1, 1, "1", "1", 2),
        (8, 1, "8", "1", 9),
    ])
    func viewModel_rollTwice_frameScoreIsSum(firstRoll: Int, secondRoll: Int, firstScore: String, secondScore: String, frameScore: Int) {
        var sut = ViewModel()
        
        sut.roll(firstRoll)
        sut.roll(secondRoll)

        #expect(sut.frameScores == [frameScore, nil, nil, nil, nil, nil, nil, nil, nil, nil])
        #expect(sut.rollScores == [firstScore, secondScore])
    }
    
    @Test
    func viewModel_rollSpare_frameScoreIsNil() {
        var sut = ViewModel()
        
        sut.roll(9)
        sut.roll(1)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["9", "/"])
    }
    
    @Test
    func viewModel_rollStrike_frameScoreIsNil() {
        var sut = ViewModel()
        
        sut.roll(10)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["X", ""])
    }

    func makeFrameScores() -> [Int?] {
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    }
}
