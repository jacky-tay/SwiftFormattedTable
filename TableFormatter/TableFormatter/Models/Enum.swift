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
    
    /// Get the proportional value for column type percentage or fixed width to the given boundary
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The value of width ratio to boundary for a column type
    func getRatioWidth(bound: Int) -> Float {
        if case .percentage(let ratio) = self {
            guard 0 <= ratio && ratio <= 1.0 else {
                fatalError("The percentage value should be range from 0.0 to 1.0")
            }
            return ratio
        }
        else if case .fixedWidth(let width) = self {
            return Float(width) / Float(bound)
        }
        return 0
    }
    
    /// Get the width of column type percentage
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The width of percentage column type with a given boundary, otherwise return nil
    func getPercentageWidth(withBound bound: Int) -> Int? {
        if case .percentage(let ratio) = self {
            guard 0 <= ratio && ratio <= 1.0 else {
                fatalError("The percentage value should be range from 0.0 to 1.0")
            }
            return Int(floor(Float(bound) * ratio))
        }
        return nil
    }
    
    /// Get the width of column type fixed width
    ///
    /// - Returns: The width of fixed width column type, otherwise return nil
    func getFixedWidth() -> Int? {
        if case .fixedWidth(let width) = self {
            return width
        }
        return nil
    }
    
    /// Get the width of column type if it is fixed width type or percentage type
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The width of column type
    func getWidth(widthBound bound: Int) -> Int? {
        return getFixedWidth() ?? getPercentageWidth(withBound: bound)
    }
    
    /// Check the column type and return `True` if such type is equally spacing or equally spacing with type
    ///
    /// - Returns: `True` if type is equally spacing or equally spacing with factor type, otherwise `False`
    func isEquallySpaced() -> Bool {
        switch self {
        case .equallySpacing, .equallySpacingWith(factor: _):
            return true
        default:
            return false
        }
    }
    
    /// Get the spacing factor
    /// 1) return 1 for equally spacing and expand to fit type
    /// 2) return the factor valur for equally spacing with factor type
    ///
    /// otherwise return 0
    /// - Returns: The spacing factor
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
