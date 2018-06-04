//
//  Cell.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

class Cell: InstanceCell {
    var content: String
    var alignment = Alignment.left
    var type = ColumnType.equallySpacing
    
    init(content: String, alignment: Alignment = .left, type: ColumnType = .equallySpacing) {
        self.content = content
        self.alignment = alignment
        self.type = type
    }
    
    func toString() -> String {
        return content
    }
    
    /// Estimate the column width
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: Estimated column width
    func estimateWidth(withBound bound: Int) -> Int {
        if case ColumnType.equallySpacingWith(factor: let factor) = type {
            return factor
        }
        return width(withBound: bound) ?? 1
    }
    
    
    /// Return the width of column if
    /// 1) column has a fixed-width or is proportional to boundary
    /// 2) column is shrink to fit, then return the length of string
    ///
    /// else return nil
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: Width for column
    func width(withBound bound: Int) -> Int? {
        if let width = type.getWidth(widthBound: bound) {
            return width
        }
        else if case ColumnType.shrinkToFit = type {
            return content.count
        }
        return nil
    }
}
