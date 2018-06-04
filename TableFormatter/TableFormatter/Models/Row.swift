//
//  Row.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

class Row {
    var cells: [Cell]
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    
    /// Calculate the total actual column count for a given columns array
    ///
    /// - Parameter columns: A list of columns
    /// - Returns: The total actual column count
    func getTotalCount(columns: [InstanceCell]) -> Int {
        return columns.reduce(0) { $0 + (($1 as? Spannable)?.span ?? 1) }
    }
    
    /// Estimate the column width can fit within the given boundary
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: `True` if the estimated width fit within the boundary, otherwise `False`
    private func areCellsWidthValid(withBound bound: Int) -> Bool {
        let estimatedColumnCharactersCount = cells.reduce(0) { $0 + ($1.estimateWidth(withBound: bound)) }
        let totalSpaceCount = max(cells.count - 1, 0) * getSpaceWidth()
        return (estimatedColumnCharactersCount + totalSpaceCount) <= bound
    }
    
    /// Find the corresponding content from the given index
    ///
    /// - Parameters:
    ///   - index: The index
    ///   - contents: The list of printable content column
    ///   - references: The column pointer references
    ///   - pointers: The column index reference
    /// - Returns: The printable content at index, the starting index, the lenght of column, the text alignment, should wrap column's content
    private func findContent(at index: Int, from contents: [InstanceCell], with references: [Pointer], and pointers: inout [Int]) -> (String, Int, Int, Alignment, Bool) {
        let totalContentColumnCount = contents.reduce(0) { $0 + (($1 as? Spannable)?.span ?? 1) }
        guard totalContentColumnCount == cells.count else {
            fatalError("The total number of cells does not match with column count")
        }
        var anchor = 0
        var count = 0
        var span = 1
        var alignment = Alignment.left
        // Loop from starting column until the it is match with the given index
        for i in 0 ..< contents.count {
            span = (contents[i] as? Spannable)?.span ?? 1
            alignment = (contents[i] as? Spannable)?.alignment ?? cells[i].alignment
            if count >= index {
                anchor = i
                break
            }
            count += span
        }
        var content = contents[anchor].toString()
        let start = references[anchor].start
        let end = references[anchor + span - 1].end
        let columnLen = end - start
        // content become repeating char if such column is fillable
        if let fill = contents[anchor] as? Fillable {
            content = String.buildRepeated(char: fill.char, withBound: columnLen)
        }
        
        let actualContentLen = content.count
        // find the first new line character or last space character and use it as pointer reference for wrapping content
        let next = content.findNextPointer(startFrom: pointers[index], withLen: columnLen)
        
        content = content.subString(from: pointers[index], withLen: next - pointers[index])

        pointers[index] = pointers[index] + content.count
        let shouldWrap = actualContentLen > pointers[index]

        return (content, start, columnLen, alignment, shouldWrap)
    }
    
    /// Convert the contents to printable string array
    ///
    /// - Parameters:
    ///   - bound: The width of boundary
    ///   - columns: The pointer refrences
    ///   - contents: The list of content to print
    /// - Returns: The printable string array
    func print(withBound bound: Int, andColumns columns: [Pointer], with contents: [InstanceCell]) -> [String] {
        var pointers = Array(repeating: 0, count: columns.count)
        var result = [String.buildContent(withBound: bound)]
        var shouldTerminate = false
        // termiate loop if new line is not required
        while !shouldTerminate {
            var needNewLine = false
            for index in 0 ..< columns.count {
                var (content, start, columnLen, alignment, shouldWrap) = findContent(at: index, from: contents, with: columns, and: &pointers)
                if shouldWrap {
                    needNewLine = true
                }
                
                // find the start index if alignment type is not left
                if alignment == .center {
                    start = start + Int(floor(Float(columnLen - content.count) * 0.5))
                }
                else if alignment == .right {
                    start = start + columnLen - content.count 
                }
                result[result.count - 1].replace(string: content.trimLastNewLine(), at: start)
            } // loop thru cells
            if needNewLine {
                result.append(String.buildContent(withBound: bound))
            }
            shouldTerminate = !needNewLine
        }
        return result
    }
    
    /// Convert row to printable string array
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The printable string array
    func print(withBound bound: Int) -> [String] {
        let columns = buildPointer(bound: bound)
        return print(withBound: bound, andColumns: columns, with: cells)
    }
    
    /// Get the width of space separator, if the number of column is greater than 4, then space width is 2, otherwise returns 3
    ///
    /// - Returns: The width of space
    func getSpaceWidth() -> Int {
        return cells.count > 4 ? 2 : 3
    }
    
    /// Build pointer references for columns, which represents the starting index and column's width
    ///
    /// - Parameter bound: The width of boundary
    /// - Returns: The pointers reference
    func buildPointer(bound: Int) -> [Pointer] {
        guard areCellsWidthValid(withBound: bound) else {
            fatalError("The estimated cells' width has excess the bound limit")
        }
        
        var pointers = cells.map { Pointer(column: $0, bound: bound) }
        let space = getSpaceWidth()
        
        let noCellsWithEquallySpacing = cells.reduce(true) { $0 && !$1.type.isEquallySpaced() }
        let noCellsWithExpandToFit = cells.reduce(true) { $0 && !($1.type == ColumnType.expandToFit) }
        let totalShrinkToFixWidth = processShrinkToFixCells(pointers: &pointers)
        // Use the remaining width to calculate the available width for column types such as equally spacing, equally spacing with factor, and percentage
        if !noCellsWithEquallySpacing || !noCellsWithExpandToFit {
            let remainingSpace = bound - ((cells.count - 1) * space) - totalShrinkToFixWidth // find the remaing space by subtracting all seperator space count, cells width (with fixed width, ratio width, or shrink to fit width)
            let totalSpacingCount = cells.reduce(0) { $0 + $1.type.getEquallySpacingFactor() }
            let equallySpacingWidth = Int(floor(Float(remainingSpace) / Float(totalSpacingCount)))
            for column in cells.enumerated() where column.element.type.getEquallySpacingFactor() != 0 {
                pointers[column.offset].len = column.element.type.getEquallySpacingFactor() * equallySpacingWidth
            }
        }
        
        // update pointers' starting position
        pointers.first?.start = 0
        for i in 1 ..< pointers.count {
            pointers[i].start = pointers[i - 1].end + space
        }
        pointers.last?.end = bound // allow the last pointer to end at boundary
        
        return pointers
    }
    
    /// Calculate all column which column type is shrink to fit type, find their maximum column width and update the corresponding pointers reference
    ///
    /// - Parameter pointers: The reference pointers
    /// - Returns: The total width of cells which column type is shrink to fit type
    func processShrinkToFixCells(pointers: inout [Pointer]) -> Int {
        var totalWidth = 0
        for (index, cell) in cells.enumerated() where cell.type == .shrinkToFit {
            pointers[index].len = cells[index].toString().count
            totalWidth += pointers[index].len
        }
        return totalWidth
    }
}
