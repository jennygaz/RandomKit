// The Swift Programming Language
// https://docs.swift.org/swift-book
public struct Xoshiro {
    @inlinable
    static func rotl<FixedInteger: FixedWidthInteger>(for base: FixedInteger, by shiftSize: Int) -> FixedInteger {
        return (base << shiftSize) | (base >> (FixedInteger.bitWidth - shiftSize))
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
