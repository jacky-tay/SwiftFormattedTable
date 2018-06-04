//
//  Table.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

class Table {
    var bound: Int
    var rows: [Row]
    
    init(bound: Int, rows: [Row]) {
        self.bound = bound
        self.rows = rows
    }
    
    /// Print the table
    ///
    /// - Returns: A list of printable string array
    func print() -> [String] {
        return rows.flatMap { $0.print(withBound: bound) }
    }
}
