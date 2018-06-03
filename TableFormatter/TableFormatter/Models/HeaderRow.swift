//
//  HeaderRow.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

class HeaderRow: Row {
    var lines = [[InstanceCell]]()
    
    func addLine(withCells cells: InstanceCell...) {
        lines.append(cells)
    }
    
    func addEmptyLine() {
        lines.append(Array(repeating: "", count: cells.count))
    }
    
    override func print(withBound bound: Int) -> [String] {
        let columns = buildPointer(bound: bound)
        var result = super.print(withBound: bound)
        for line in lines {
            result.append(contentsOf: print(withBound: bound, andColumns: columns, with: line))
        }
        return result
    }
    
    override func processShrinkToFixCells(pointers: inout [Pointer]) -> Int {
        var totalWidth = 0
        for (index, cell) in cells.enumerated() where cell.type == .shrinkToFit {
            pointers[index].len = maxCellWidth(at: index, withLen: pointers[index].len)
            totalWidth += pointers[index].len
        }
        return totalWidth
    }
    
    private func maxCellWidth(at index: Int, withLen len: Int) -> Int {
        var maxWidth = len
        for line in lines where (line.reduce(true) { $0 && !($1 is Spannable) }) {
            maxWidth = max(maxWidth, line[index].toString().count)
        }
        return maxWidth
    }
}
