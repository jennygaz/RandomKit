//
//  File.swift
//  
//
//  Created by Jenny Gallegos Cardenas on 28/08/24.
//

extension Xoshiro {
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
}
