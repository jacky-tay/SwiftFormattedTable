//
//  Displayable.swift
//  TableFormatter
//
//  Created by Jacky Tay on 3/06/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

protocol Displayable {
    func toString() -> String
}

typealias InstanceCell = Displayable

extension Displayable {
    
    /// Create a Span Column object, if such Displayble is not
    ///
    /// - Parameters:
    ///   - col: The number of column span
    ///   - alignment: The text alignment
    /// - Returns: A Span Column span
    func span(col: Int, alignment: Alignment = .left) -> SpanColumn {
        if let span = self as? SpanColumn {
            return span
        }
        return SpanColumn(content: toString(), span: col, alignment: alignment)
    }
}
