//
//  File.swift
//  
//
//  Created by Jenny Gallegos Cardenas on 27/08/24.
//

public protocol Randomizable {
    associatedtype StateBase: FixedWidthInteger
    mutating func next() -> StateBase
    var width: Int { get }
}

public extension Randomizable {
    var width: Int { StateBase.bitWidth }
}
