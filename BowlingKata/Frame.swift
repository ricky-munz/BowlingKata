//
//  Frame.swift
//  BowlingKata
//
//  Created by Ricky Munz on 5/30/25.
//

extension Game {
    public class Frame {
        public var roll1: Int?
        public var roll2: Int?
        public var roll3: Int?
        public var previousFrame: Frame?
        public var nextFrame: Frame?
        public var score: Int? {
            guard let localScore else {
                return nil
            }
            return localScore + previousScore
        }

        public var isStrike: Bool {
            roll1 == 10
        }

        public var isSpare: Bool {
            guard let roll1, let roll2 else {
                return false
            }
            return roll1 + roll2 == 10
        }

        var isFinal: Bool {
            nextFrame == nil
        }

        var isComplete: Bool {
            if isFinal {
                if roll3 != nil {
                    return true
                } else if roll2 != nil, !isStrike, !isSpare {
                    return true
                }
            } else {
                if isStrike {
                    return true
                } else if roll2 != nil {
                    return true
                }
            }

            return false
        }

        private var localScore: Int? {
            guard let bonusScore else {
                return nil
            }

            if !isStrike, roll2 == nil {
                return nil
            }

            return (roll1 ?? 0) + (roll2 ?? 0) + bonusScore
        }

        private var previousScore: Int {
            previousFrame?.score ?? 0
        }

        private var nextTwoRolls: Int? {
            guard
                let nextRoll1 = nextFrame?.roll1,
                let nextRoll2 = nextFrame?.roll2 ?? nextFrame?.nextFrame?.roll1
            else {
                return nil
            }

            return nextRoll1 + nextRoll2
        }

        private var bonusScore: Int? {
            if let roll3 {
                return roll3
            }
            if isStrike {
                return nextTwoRolls
            }
            if isSpare {
                return nextFrame?.roll1
            }
            return 0
        }

        func update(pins: Int) {
            if roll1 == nil {
                roll1 = pins
            } else if roll2 == nil {
                roll2 = pins
            } else {
                roll3 = pins
            }
        }
    }
}
