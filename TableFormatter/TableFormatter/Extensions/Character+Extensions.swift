//
//  Character+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 3/06/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension Character {

    func fill() -> FillColumn {
        return FillColumn(char: self)
    }
    
    func fill(spanCol col: Int) -> FillableSpanColumn {
        return FillableSpanColumn(char: self, span: col)
    }
}
