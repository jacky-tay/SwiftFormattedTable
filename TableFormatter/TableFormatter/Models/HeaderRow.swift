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
    
    /// Add instance cells to header row
    ///
    /// - Parameter cells: A list of instance cells
    func addLine(withCells cells: InstanceCell...) {
        guard getTotalCount(columns: cells) == getTotalCount(columns: self.cells) else {
            fatalError("The number of instance cells must equal to the header cells")
        }
        lines.append(cells)
    }
    
    /// Add empty line to header row. Arbitrary cells with empty string are added.
    func addEmptyLine() {
        lines.append(Array(repeating: "", count: cells.count))
    }
    
    /// Convert all rows to printable string array
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The printable string array
    override func print(withBound bound: Int) -> [String] {
        let columns = buildPointer(bound: bound)
        var result = super.print(withBound: bound)
        for line in lines {
            result.append(contentsOf: print(withBound: bound, andColumns: columns, with: line))
        }
        return result
    }
    
    /// Calculate all column which column type is shrink to fit type, find their maximum column width and update the corresponding pointers reference
    ///
    /// - Parameter pointers: The reference pointers
    /// - Returns: The total width of cells which column type is shrink to fit type
    override func processShrinkToFixCells(pointers: inout [Pointer]) -> Int {
        var totalWidth = 0
        for (index, cell) in cells.enumerated() where cell.type == .shrinkToFit {
            pointers[index].len = maxCellWidth(at: index, withLen: pointers[index].len)
            totalWidth += pointers[index].len
        }
        return totalWidth
    }
    
    /// Find the maximum column width at a given index, any row with spannble column is not included in the calculation
    ///
    /// - Parameters:
    ///   - index: The index of column
    ///   - len: The length of a column at index
    /// - Returns: The maximum column width at index
    private func maxCellWidth(at index: Int, withLen len: Int) -> Int {
        var maxWidth = len
        for line in lines where (line.reduce(true) { $0 && !($1 is Spannable) }) {
            maxWidth = max(maxWidth, line[index].toString().count)
        }
        return maxWidth
    }
}
