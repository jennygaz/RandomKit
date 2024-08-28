//
//  File.swift
//  
//
//  Created by Jenny Gallegos Cardenas on 28/08/24.
//

extension Xoshiro {
    public struct Xoshiro128Plus: Randomizable & Jumpable {
        public typealias State = (UInt32, UInt32, UInt32, UInt32)
        public private(set) var state: State = (0, 0, 0, 0)

        @discardableResult
        public mutating func next() -> UInt32 {
            let result = state.0 + state.3
            
            let tmp = state.1 << 9
            state.2 ^= state.0
            state.3 ^= state.1
            state.1 ^= state.2
            state.0 ^= state.3
            state.2 ^= tmp
            state.3 = rotl(for: state.3, by: 11)
            
            return result
        }
        
        public mutating func jump() {
            let jumpConstants: [StateBase] = [
                0x8764000b,
                0xf542d2d3,
                0x6fa035c3,
                0x77f2db5b
            ]
            
            var substate: State = (0, 0, 0, 0)
            for constant in jumpConstants {
                for bit in 0..<StateBase.bitWidth {
                    if (constant & UInt32(1) << bit) != 0 {
                        substate.0 ^= state.0
                        substate.1 ^= state.1
                        substate.2 ^= state.2
                        substate.3 ^= state.3
                    }
                    next()
                }
                state = substate
            }
        }

        public mutating func longJump() {
            let longJumpConstants: [StateBase] = [
                0xb523952e,
                0x0b6f099f,
                0xccf5a0ef,
                0x1c580662
            ]
            
            var substate: State = (0, 0, 0, 0)
            for constant in longJumpConstants {
                for bit in 0..<StateBase.bitWidth {
                    if (constant & UInt32(1) << bit) != 0 {
                        substate.0 ^= state.0
                        substate.1 ^= state.1
                        substate.2 ^= state.2
                        substate.3 ^= state.3
                    }
                    next()
                }
                state = substate
            }
        }
    }
}
