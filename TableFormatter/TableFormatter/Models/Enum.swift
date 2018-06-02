//
//  Enum.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

enum Alignment {
    case left
    case right
    case center
}

enum ColumnType {
    case shrinkToFit
    case expandToFit
    case equallySpacing
    case equallySpacingWith(factor: Int)
    case fixedWidth(Int)
    case percentage(Float) // range between 0.0 ... 1.0
    
    static func ==(lhs: ColumnType, rhs: ColumnType) -> Bool {
        switch (lhs, rhs) {
        case (.shrinkToFit, .shrinkToFit), (.expandToFit, .expandToFit), (.equallySpacing, .equallySpacing):
            return true
        default:
            return false
        }
    }
    
    func getRatioWidth(bound: Int) -> Float {
        if case .percentage(let ratio) = self {
            return ratio
        }
        else if case .fixedWidth(let width) = self {
            return Float(width) / Float(bound)
        }
        return 0
    }
    
    func getPercentageWidth(withBound bound: Int) -> Int? {
        if case .percentage(let ratio) = self {
            return Int(floor(Float(bound) * ratio))
        }
        return nil
    }
    
    func getFixedWidth() -> Int? {
        if case .fixedWidth(let width) = self {
            return width
        }
        return nil
    }
    
    func getWidth(widthBound bound: Int) -> Int? {
        return getFixedWidth() ?? getPercentageWidth(withBound: bound)
    }
    
    func isEquallySpaced() -> Bool {
        switch self {
        case .equallySpacing, .equallySpacingWith(factor: _):
            return true
        default:
            return false
        }
    }
    
    func getEquallySpacingFactor() -> Int {
        switch self {
        case .equallySpacing, .expandToFit:
            return 1
        case .equallySpacingWith(factor: let factor):
            return factor
        default:
            return 0
        }
    }
}
