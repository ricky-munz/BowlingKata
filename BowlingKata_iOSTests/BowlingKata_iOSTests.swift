//
//  BowlingKata_iOSTests.swift
//  BowlingKata_iOSTests
//
//  Created by Ricky Munz on 12/12/24.
//

import Testing
@testable import BowlingKata_iOS

struct BowlingKata_iOSTests {
    let sut: ViewModel
    
    init() {
        sut = ViewModel()
    }
    
    @Test func viewModel_onInit_hasTenFrames() {
        #expect(sut.frameScores.count == 10)
    }
    
    @Test(arguments: [
        (0, "0"),
        (1, "1"),
        (9, "9")
    ])
    func viewModel_rollOnce_rollScoreMatchesInput(roll: Int, score: String) {
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
        sut.roll(firstRoll)
        sut.roll(secondRoll)
        
        #expect(sut.frameScores == makeFrameScores(firstScore: frameScore))
        #expect(sut.rollScores == [firstScore, secondScore])
    }
    
    @Test
    func viewModel_rollSpare_frameScoreIsNil() {
        sut.roll(9)
        sut.roll(1)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["9", "/"])
    }
    
    @Test
    func viewModel_rollStrike_frameScoreIsNil() {
        sut.roll(10)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["X", ""])
    }
    
    @Test
    func viewModel_rollThreeTimes_frameScoreIsCorrect() {
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
        sut.roll(1)
        sut.roll(1)
        sut.roll(thirdRoll)
        sut.roll(fourthRoll)
        
        #expect(sut.frameScores == makeFrameScores(firstScore: "2", secondScore: secondFrameScore))
        #expect(sut.rollScores == ["1", "1", thirdRollScore, fourthRollScore])
    }
    
    @Test
    func viewModel_rollSpareFirstFrame_frameScoreAddsZeroBonus() {
        sut.roll(9)
        sut.roll(1)
        sut.roll(0)
        
        #expect(sut.frameScores == makeFrameScores(firstScore: "10"))
        #expect(sut.rollScores == ["9", "/", "0"])
    }
    
    @Test(arguments: [
        (rolls: [10, 10, 10], expectedScores: ["X", "X", "X"]),
        (rolls: [10, 5, 5], expectedScores: ["X", "5", "/"]),
        (rolls: [10, 3, 3], expectedScores: ["X", "3", "3"]),
        (rolls: [8, 2, 3], expectedScores: ["8", "/", "3"]),
        (rolls: [8, 2, 10], expectedScores: ["8", "/", "X"])
    ])
    func viewModel_onFinalFrame_displaysRollsCorrectly(rolls: [Int], expectedScores: [String]) {
        rollStrikesForNineFrames()

        for roll in rolls {
            sut.roll(roll)
        }

        #expect(sut.rollScores.suffix(3) == expectedScores)
    }
    
    @Test
    func viewModel_reset_clearsFramesAndScores() {
        rollStrikesForNineFrames()
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        
        sut.reset()
        
        #expect(sut.frameScores == Array(repeating: "", count: 10))
        #expect(sut.rollScores == [])
        #expect(sut.isGameCompleted == false)
    }
    
    @Test
    func viewModel_reset_startsNewGame() {
        rollStrikesForNineFrames()
        sut.roll(10)
        sut.roll(10)
        sut.roll(10)
        
        sut.reset()
        sut.roll(4)
        
        #expect(sut.frameScores == makeFrameScores())
        #expect(sut.rollScores == ["4"])
    }

    @Test
    func viewModel_roll_withValidPins_rolls() {
        sut.pins = "1"
        sut.roll()
        #expect(!sut.isRollInvalid)
    }

    @Test
    func viewModel_roll_withInvalidPins_presentsAlert() {
        sut.pins = "a"
        sut.roll()
        #expect(sut.isRollInvalid)
        sut.pins = "-1"
        sut.roll()
        #expect(sut.isRollInvalid)
        sut.pins = "11"
        sut.roll()
        #expect(sut.isRollInvalid)
    }

    // MARK: Helpers

    func makeFrameScores(firstScore: String = "", secondScore: String = "") -> [String] {
        [firstScore, secondScore, "", "", "", "", "", "", "", ""]
    }

    func rollStrikesForNineFrames() {
        for _ in 0..<9 {
            sut.roll(10)
        }
    }
}
