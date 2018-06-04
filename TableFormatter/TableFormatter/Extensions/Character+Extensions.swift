//
//  Character+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 3/06/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension Character {

    /// Convert character to Fill Column object
    ///
    /// - Returns: The Fill Column object
    func fill() -> FillColumn {
        return FillColumn(char: self)
    }
    
    /// Convert character to Fillable Span Column object
    ///
    /// - Parameter col: The number of span column
    /// - Returns: The Fillable Span Column object
    func fill(spanCol col: Int) -> FillableSpanColumn {
        return FillableSpanColumn(char: self, span: col)
    }
}
