//
//  GameTests.swift
//  BowlingKataTests
//
//  Created by Ricky Munz on 11/22/24.
//

import XCTest
@testable import BowlingKata

final class GameTests: XCTestCase {
    private var game: Game!

    override func setUp() {
        super.setUp()
        game = Game()
    }

    override func tearDown() {
        game = nil
        super.tearDown()
    }

    func testGutterGame() {
        rollMany(pins: 0, times: 20)
        XCTAssertEqual(game.score(), 0)
        XCTAssertEqual(game.frameScores, Array(repeating: 0, count: 10))
    }

    func testAllOnes() {
        rollMany(pins: 1, times: 20)
        XCTAssertEqual(game.score(), 20)
        XCTAssertEqual(game.frameScores, [2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
    }
    
    func testSpareNotScoredWithoutBonus() {
        rollSpare()
        
        XCTAssertEqual(game.score(), 10)
        XCTAssertEqual(game.frameScores, Array(repeating: nil, count: 10))
    }

    func testStrikeNotScoredWithoutBonus() {
        rollStrike()

        XCTAssertEqual(game.score(), 10)
        XCTAssertEqual(game.frameScores, Array(repeating: nil, count: 10))
    }

    func testOneSpare() {
        rollSpare()
        game.roll(3)
        rollMany(pins: 0, times: 17)
        
        XCTAssertEqual(game.score(), 16)
        XCTAssertEqual(game.frameScores, [13, 16, 16, 16, 16, 16, 16, 16, 16, 16])
    }

    func testStrikeAndThenOneRollDoesNotScoreFrame() {
        rollStrike()
        game.roll(3)

        XCTAssertEqual(game.frameScores, Array(repeating: nil, count: 10))
    }

    func testStrikeAndThenTwoRollsScoresFrame() {
        rollStrike()
        game.roll(3)
        game.roll(3)

        XCTAssertEqual(game.frameScores, [16, 22, nil, nil, nil, nil, nil, nil, nil, nil])
    }

    func testOneStrikeWithBonusAndZerosScoresFrames() {
        rollStrike()
        game.roll(3)
        game.roll(4)
        rollMany(pins: 0, times: 16)
        
        XCTAssertEqual(game.score(), 24)
        XCTAssertEqual(game.frameScores, [17, 24, 24, 24, 24, 24, 24, 24, 24, 24])
    }

    func testPerfectGame() {
        rollMany(pins: 10, times: 12)
        
        XCTAssertEqual(game.score(), 300)
    }

    // MARK: - Frame Tests
    func testRollOnceFrameRollSet() {
        game.roll(4)

        XCTAssertEqual(game.frames[0].roll1, 4)
        XCTAssertEqual(game.frames[0].roll2, nil)
    }

    func testRollTwiceFrameRollsSet() {
        game.roll(1)
        game.roll(2)

        XCTAssertEqual(game.frames[0].roll1, 1)
        XCTAssertEqual(game.frames[0].roll2, 2)
    }

    func testRoll4TimesFrameRollsSet() {
        game.roll(1)
        game.roll(2)
        game.roll(3)
        game.roll(4)

        XCTAssertEqual(game.frames[0].roll1, 1)
        XCTAssertEqual(game.frames[0].roll2, 2)
        XCTAssertEqual(game.frames[1].roll1, 3)
        XCTAssertEqual(game.frames[1].roll2, 4)
    }

    // MARK: - Helpers
    private func rollMany(pins: Int, times: Int) {
        for _ in 1...times {
            game.roll(pins)
        }
    }
    
    private func rollSpare() {
        game.roll(5)
        game.roll(5)
    }
    
    private func rollStrike() {
        game.roll(10)
    }
}
