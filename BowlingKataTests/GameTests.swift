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

    func test_gutterGame() {
        rollMany(pins: 0, times: 20)
    }

    func test_allOnes() {
        rollMany(pins: 1, times: 20)
    }
    
    func test_spare_withoutRequiredBonusRolls_notScored() {
        rollSpare()
        
        XCTAssertEqual(game.frames[0].score, nil)
    }

    func test_strike_withOnlyOneRequiredBonusRoll_doesNotScoreFrame() {
        rollStrike()

        XCTAssertEqual(game.frames[0].roll1, 10)
        XCTAssertEqual(game.frames[0].roll2, nil)
        XCTAssertEqual(game.frames[0].score, nil)
    }

    func test_spare_withRequiredBonusRollAndGutterBalls_scoresGame() {
        rollSpare()
        game.roll(3)
        rollMany(pins: 0, times: 17)
        
        XCTAssertEqual(game.frames[0].score, 13)
        XCTAssertEqual(game.frames[1].score, 16)
        XCTAssertEqual(game.frames[9].score, 16)
    }

    func test_rollZeroThenTen_scoresSpare() {
        game.roll(0)
        game.roll(10)
        game.roll(3)

        XCTAssertEqual(game.frames[0].score, 13)
        XCTAssertEqual(game.frames[1].score, nil)
    }

    func test_rollMultipleSpares_scoresFrames() {
        game.roll(3)
        game.roll(7)
        game.roll(5)
        game.roll(5)
        game.roll(4)
        game.roll(6)

        XCTAssertEqual(game.frames[0].score, 15)
        XCTAssertEqual(game.frames[1].score, 29)
        XCTAssertEqual(game.frames[2].score, nil)
    }

    func test_strike_withOneRequiredBonusRoll_doesNotScoreFrame() {
        rollStrike()
        game.roll(3)

        XCTAssertEqual(game.frames[0].roll1, 10)
        XCTAssertEqual(game.frames[0].roll2, nil)
        XCTAssertEqual(game.frames[0].score, nil)
    }

    func test_strike_withTwoRequiredBonusRolls_scoresFrame() {
        rollStrike()
        game.roll(3)
        game.roll(3)

        XCTAssertEqual(game.frames[0].roll1, 10)
        XCTAssertEqual(game.frames[0].roll2, nil)
        XCTAssertEqual(game.frames[1].roll1, 3)
        XCTAssertEqual(game.frames[1].roll2, 3)
        XCTAssertEqual(game.frames[0].score, 16)
        XCTAssertEqual(game.frames[1].score, 22)
    }

    func test_strike_withTwoRequiredBonusRollsAndGutterBalls_scoresGame() {
        rollStrike()
        game.roll(3)
        game.roll(4)
        rollMany(pins: 0, times: 16)
        
        XCTAssertEqual(game.frames[0].score, 17)
        XCTAssertEqual(game.frames[1].score, 24)
        XCTAssertEqual(game.frames[9].score, 24)
    }

    func test_threeStrikes_scoresFirstFrame() {
        rollStrike()
        rollStrike()
        rollStrike()

        XCTAssertEqual(game.frames[0].score, 30)
        XCTAssertEqual(game.frames[1].score, nil)
        XCTAssertEqual(game.frames[2].score, nil)
    }

    func test_perfectGame() {
        rollMany(pins: 10, times: 12)
        
        XCTAssertEqual(game.frames[0].score, 30)
        XCTAssertEqual(game.frames[1].score, 60)
        XCTAssertEqual(game.frames[2].score, 90)
        XCTAssertEqual(game.frames[9].score, 300)
    }

    func test_strikeInLastFrame_thenSpare_scoresBonus() {
        rollMany(pins: 10, times: 9)

        rollStrike()
        game.roll(3)
        game.roll(7)

        XCTAssertEqual(game.frames[8].score, 263)
        XCTAssertEqual(game.frames[9].score, 283)
    }

    func test_spareInLastFrame_scoresBonus() {
        rollMany(pins: 0, times: 18)

        rollSpare()
        game.roll(3)

        XCTAssertEqual(game.frames[8].score, 0)
        XCTAssertEqual(game.frames[9].score, 13)
    }

    func test_regularLastFrame_onlyScoresTwoRolls() {
        rollMany(pins: 0, times: 18)
        
        game.roll(3)
        game.roll(4)

        XCTAssertEqual(game.frames[8].score, 0)
        XCTAssertEqual(game.frames[9].score, 7)
    }

    // MARK: - Frame Tests
    func test_beforeRolling_doesNotSetFrame() {
        XCTAssertEqual(game.frames[0].roll1, nil)
        XCTAssertEqual(game.frames[0].roll2, nil)
        XCTAssertEqual(game.frames[0].score, nil)
    }

    func test_rollOnce_setsFrame() {
        game.roll(4)

        XCTAssertEqual(game.frames[0].roll1, 4)
        XCTAssertEqual(game.frames[0].roll2, nil)
        XCTAssertEqual(game.frames[0].score, nil)
    }

    func test_rollTwice_setsAndScoresFrame() {
        game.roll(1)
        game.roll(2)

        XCTAssertEqual(game.frames[0].roll1, 1)
        XCTAssertEqual(game.frames[0].roll2, 2)
        XCTAssertEqual(game.frames[0].score, 3)
    }

    func test_rollFourTimes_setsAndScoresFrames() {
        game.roll(1)
        game.roll(2)
        game.roll(3)
        game.roll(4)

        XCTAssertEqual(game.frames[0].roll1, 1)
        XCTAssertEqual(game.frames[0].roll2, 2)
        XCTAssertEqual(game.frames[1].roll1, 3)
        XCTAssertEqual(game.frames[1].roll2, 4)
        XCTAssertEqual(game.frames[0].score, 3)
        XCTAssertEqual(game.frames[1].score, 10)
    }

    func test_rollGameOfAllOnes_exceptLastRoll_gameIsNotFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 1, times: 19)

        XCTAssertEqual(completionCount, 0)
    }

    func test_rollGameOfAllStrikes_exceptLastRoll_gameIsNotFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 10, times: 11)

        XCTAssertEqual(completionCount, 0)
    }

    func test_rollGameOfAllSpares_exceptLastRoll_gameIsNotFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 5, times: 20)

        XCTAssertEqual(completionCount, 0)
    }

    func test_rollGameOfAllOnes_gameIsFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 1, times: 20)

        XCTAssertEqual(completionCount, 1)
    }

    func test_rollGameOfStrikes_gameIsFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 10, times: 11)
        rollStrike()

        XCTAssertEqual(completionCount, 1)
    }

    func test_rollGameWithLastFrameSpares_gameIsFinished() {
        var completionCount = 0
        game = Game {
            completionCount += 1
        }

        rollMany(pins: 10, times: 9)
        rollSpare()
        game.roll(1)

        XCTAssertEqual(completionCount, 1)
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
