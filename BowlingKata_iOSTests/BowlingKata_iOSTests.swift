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
        let sut = ViewModel()

        sut.roll(roll)

        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == [score])
    }

    @Test(arguments: [
        (0, 0, "0", "0", "0"),
        (0, 1, "0", "1", "1"),
        (1, 0, "1", "0", "1"),
        (1, 1, "1", "1", "2"),
        (8, 1, "8", "1", "9"),
    ])
    func viewModel_rollTwice_frameScoreIsSum(firstRoll: Int, secondRoll: Int, firstScore: String, secondScore: String, frameScore: String) {
        let sut = ViewModel()
        
        sut.roll(firstRoll)
        sut.roll(secondRoll)

        #expect(sut.frameScores == makeFrameScores(firstScore: frameScore))
        #expect(sut.rollScores == [firstScore, secondScore])
    }
    
    @Test
    func viewModel_rollSpare_frameScoreIsNil() {
        let sut = ViewModel()
        
        sut.roll(9)
        sut.roll(1)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["9", "/"])
    }
    
    @Test
    func viewModel_rollStrike_frameScoreIsNil() {
        let sut = ViewModel()
        
        sut.roll(10)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["X", ""])
    }
    
    @Test
    func viewModel_rollThreeTimes_frameScoreIsCorrect() {
        let sut = ViewModel()
        
        sut.roll(1)
        sut.roll(1)
        sut.roll(1)
        
        #expect(sut.frameScores == makeFrameScores(firstScore: "2"))
        #expect(sut.rollScores == ["1", "1", "1"])
    }
    
    @Test(arguments: [
        (0, 0, "0", "0", "2"),
        (1, 1, "1", "1", "4"),
        (0, 8, "0", "8", "10"),
    ])
    func viewModel_rollSecondFrame_frameScoreIsCorrect(thirdRoll: Int, fourthRoll: Int, thirdRollScore: String, fourthRollScore: String, secondFrameScore: String) {
        let sut = ViewModel()
        
        sut.roll(1)
        sut.roll(1)
        sut.roll(thirdRoll)
        sut.roll(fourthRoll)

        #expect(sut.frameScores == makeFrameScores(firstScore: "2", secondScore: secondFrameScore))
        #expect(sut.rollScores == ["1", "1", thirdRollScore, fourthRollScore])
    }
    
    @Test
    func viewModel_rollSpareFirstFrame_frameScoreAddsZeroBonus() {
        let sut = ViewModel()
        
        sut.roll(9)
        sut.roll(1)
        sut.roll(0)
        
        #expect(sut.frameScores == makeFrameScores(firstScore: "10"))
        #expect(sut.rollScores == ["9", "/", "0"])
    }
    
    @Test
    func viewModel_rollPerfectGame_rollScoresDisplays3XsInFinalFrame() {
        let sut = ViewModel()
        
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        
        #expect(sut.frameScores == ["30", "60", "90", "120", "150", "180", "210", "240", "270", "300"])
        #expect(sut.rollScores == ["X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "X", "X"])
    }
    
    @Test
    func viewModel_rollSpareAtEnd_rollScoresDisplaysXAndSlashInFinalFrame() {
        let sut = ViewModel()
        
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        sut.roll(5)
        sut.roll(5)
        
        #expect(sut.frameScores == ["30", "60", "90", "120", "150", "180", "210", "240", "265", "285"])
        #expect(sut.rollScores == ["X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "", "X", "5", "/"])
    }

    func makeFrameScores(firstScore: String = "", secondScore: String = "") -> [String] {
        [firstScore, secondScore, "", "", "", "", "", "", "", ""]
    }
}
