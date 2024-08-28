//
//  File.swift
//  
//
//  Created by Jenny Gallegos Cardenas on 28/08/24.
//

extension Xoshiro {
    public struct Xoroshiro128Plus: Randomizable & Jumpable {
        public typealias State = (UInt64, UInt64)
        public private(set) var state: State = (0, 0)

        @discardableResult
        public mutating func next() -> UInt64 {
            let lhs = state.0
            var rhs = state.1
            let result = lhs &+ rhs
            rhs ^= lhs
            state = (
                rotl(for: lhs, by: 24) ^ rhs ^ (rhs << 16),
                rotl(for: rhs, by: 37)
            )
            return result
        }

        public mutating func jump() {
            let jumpConstants: [UInt64] = [
                0xdf900294d8f554a5,
                0x170865df4b3201fc
            ]
            
            var lhs: UInt64 = 0
            var rhs: UInt64 = 0
            
            for constant in jumpConstants {
                for bit in 0..<StateBase.bitWidth {
                    if (constant & UInt64(1) << bit) != 0 {
                        lhs ^= state.0
                        rhs ^= state.1
                    }
                    next()
                }
                state = (lhs, rhs)
            }
        }

        public mutating func longJump() {
            let longJumpConstants: [UInt64] = [
                0xd2a98b26625eee7b,
                0xdddf9b1090aa7ac1
            ]
            
            var lhs: UInt64 = 0
            var rhs: UInt64 = 0
            
            for constant in longJumpConstants {
                for bit in 0..<StateBase.bitWidth {
                    if (constant & UInt64(1) << bit) != 0 {
                        lhs ^= state.0
                        rhs ^= state.1
                    }
                    next()
                }
                state = (lhs, rhs)
            }
        }
    }
}
