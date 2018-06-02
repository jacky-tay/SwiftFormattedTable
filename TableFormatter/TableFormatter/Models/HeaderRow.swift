//
//  HeaderRow.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

protocol Displayable {
    func toString() -> String
}

typealias InstanceCell = Displayable

class HeaderRow: Row {
    var lines = [[InstanceCell]]()
    
    func addLine(withCells cells: InstanceCell...) {
        lines.append(cells)
    }
    
    override func print(withBound bound: Int) -> [String] {
        let columns = buildPointer(bound: bound)
        var result = super.print(withBound: bound)
        for line in lines {
            result.append(contentsOf: print(withBound: bound, andColumns: columns, with: line))
        }
        return result
    }
}
