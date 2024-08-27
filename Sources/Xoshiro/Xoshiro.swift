// The Swift Programming Language
// https://docs.swift.org/swift-book
public struct Xoshiro {
    @inlinable
    static func rotl<FixedInteger: FixedWidthInteger>(for base: FixedInteger, by shiftSize: Int) -> FixedInteger {
        return (base << shiftSize) | (base >> (FixedInteger.bitWidth - shiftSize))
    }
    
    public struct Xoroshiro64Star: Randomizable {
        public typealias State = (UInt32, UInt32)
        public private(set) var state: State = (0, 0)
        private let constant: UInt32 = 0x9E3779BB
        public mutating func next() -> UInt32 {
            let lhs = state.0
            var rhs = state.1
            let result = lhs &* constant
            rhs ^= lhs
            self.state = (
                rotl(for: lhs, by: 26) ^ rhs ^ (rhs << 9),
                rotl(for: rhs, by: 13)
            )
            return result
        }
    }
    
    public struct Xoroshiro64StarStar: Randomizable {
        public typealias State = (UInt32, UInt32)
        public private(set) var state: State = (0, 0)
        private let constant: UInt32 = 0x9E3779BB
        public mutating func next() -> UInt32 {
            let lhs = state.0
            var rhs = state.1
            let result = rotl(for: lhs * constant, by: 5) &* 5
            rhs ^= lhs
            self.state = (
                rotl(for: lhs, by: 26) ^ rhs ^ (lhs << 9),
                rotl(for: rhs, by: 13)
            )
            return result
        }
    }
    
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
    
    public struct Xoroshiro128PlusPlus: Randomizable & Jumpable {
        public typealias State = (UInt64, UInt64)
        public private(set) var state: State = (0, 0)
        
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
            <#code#>
        }
        
        public mutating func longJump() {
            <#code#>
        }
    }
    
    enum PRNG {
        case xoroshiro2x32Star
        case xoroshiro2x32StarStar
        case xoshiro4x32Plus
        case xoshiro4x32PlusPlus
        case xoshiro4x32StarStar
        case xoroshiro2x64Plus
        case xoroshiro2x64PlusPlus
        case xoroshiro2x64StarStar
        case xoshiro4x64Plus
        case xoshiro4x64PlusPlus
        case xoshiro4x64StarStar
        case xoshiro8x64Plus
        case xoshiro8x64PlusPlus
        case xoshiro8x64StarStar
        case xoroshiro16x64PlusPlus
        case xoroshiro16x64Star
        case xoroshiro16x64StarStar
    }
}
