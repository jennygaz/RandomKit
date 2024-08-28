//
//  File.swift
//  
//
//  Created by Jenny Gallegos Cardenas on 28/08/24.
//

extension Xoshiro {
    public struct Xoroshiro128PlusPlus: Randomizable & Jumpable {
        public typealias State = (UInt64, UInt64)
        public private(set) var state: State = (0, 0)

        @discardableResult
        public mutating func next() -> UInt64 {
            let lhs = state.0
            var rhs = state.1
            let result = rotl(for: lhs &+ rhs, by: 17) &+ lhs
            rhs ^= lhs
            state = (
                rotl(for: lhs, by: 49) ^ rhs ^ (rhs << 21),
                rotl(for: rhs, by: 28)
            )
            return result
        }
        
        public mutating func jump() {
            let jumpConstants: [UInt64] = [
                0x2bd7a6a6e99c2ddc,
                0x0992ccaf6a6fca05
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
                0x360fd5f2cf8d5d99,
                0x9c6e6877736c46e3
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
