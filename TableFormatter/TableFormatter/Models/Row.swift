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
    
    func areCellsWidthValid(withBound bound: Int) -> Bool {
        let estimatedColumnCharactersCount = cells.reduce(0) { $0 + ($1.estimateWidth(withBound: bound)) }
        let totalSpaceCount = max(cells.count - 1, 0) * getSpaceWidth()
        return (estimatedColumnCharactersCount + totalSpaceCount) <= bound
    }
    
    func findContent(at index: Int, from contents: [InstanceCell], with references: [Pointer], and pointers: inout [Int]) -> (String, Int, Int, Alignment, Bool) {
        let totalContentColumnCount = contents.reduce(0) { $0 + (($1 as? Spannable)?.span ?? 1) }
        guard totalContentColumnCount == cells.count else {
            fatalError("The total number of cells does not match with column count")
        }
        var anchor = 0
        var count = 0
        var span = 1
        var alignment = Alignment.left
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
        if let fill = contents[anchor] as? Fillable {
            content = String.buildRepeated(char: fill.char, withBound: columnLen)
        }
        
        let actualContentLen = content.count
        let next = content.findNextPointer(startFrom: pointers[index], withLen: columnLen)
        
        content = content.subString(from: pointers[index], withLen: next - pointers[index])

        pointers[index] = pointers[index] + content.count
        let shouldWrap = actualContentLen > pointers[index]

        return (content, start, columnLen, alignment, shouldWrap)
    }
    
    func print(withBound bound: Int, andColumns columns: [Pointer], with contents: [InstanceCell]) -> [String] {
        var pointers = Array(repeating: 0, count: columns.count)
        var result = [String.buildContent(withBound: bound)]
        var shouldTerminate = false
        
        while !shouldTerminate {
            var needNewLine = false
            for index in 0 ..< columns.count {
                var (content, start, columnLen, alignment, shouldWrap) = findContent(at: index, from: contents, with: columns, and: &pointers)
                if shouldWrap {
                    needNewLine = true
                }
                if alignment == .center {
                    start = start + Int(floor(Float(columnLen - content.count) * 0.5))
                }
                else if alignment == .right {
                    start = start + columnLen - content.count 
                }

                result[result.count - 1].replace(string: content, at: start)
            } // loop thru cells
            if needNewLine {
                result.append(String.buildContent(withBound: bound))
            }
            shouldTerminate = !needNewLine
        }
        return result
    }
    
    func print(withBound bound: Int) -> [String] {
        let columns = buildPointer(bound: bound)
        return print(withBound: bound, andColumns: columns, with: cells)
    }
    
    func getSpaceWidth() -> Int {
        return cells.count > 4 ? 2 : 3
    }
    
    func buildPointer(bound: Int) -> [Pointer] {
        guard areCellsWidthValid(withBound: bound) else {
            fatalError("The estimated cells' width has excess the bound limit")
        }
        
        var pointers = cells.map { Pointer(column: $0, bound: bound) }
        let space = getSpaceWidth()
        
        let noCellsWithEquallySpacing = cells.reduce(true) { $0 && !$1.type.isEquallySpaced() }
        let noCellsWithExpandToFit = cells.reduce(true) { $0 && !($1.type == ColumnType.expandToFit) }
        if !noCellsWithEquallySpacing || !noCellsWithExpandToFit {
            let remainingSpace = bound - ((cells.count - 1) * space) - cells.reduce(0) { $0 + ($1.width(withBound: bound) ?? 0) } // find the remaing space by subtracting all seperator space count, cells width (with fixed width, ratio width, or shrink to fit width)
            let totalSpacingCount = cells.reduce(0) { $0 + $1.type.getEquallySpacingFactor() }
            let equallySpacingWidth = Int(floor(Float(remainingSpace) / Float(totalSpacingCount)))
            for column in cells.enumerated() where column.element.type.getEquallySpacingFactor() != 0 {
                pointers[column.offset].len = column.element.type.getEquallySpacingFactor() * equallySpacingWidth
            }
        }
        
        // update pointers' starting position
        pointers.first?.start = 0
        for i in 1 ..< pointers.count {
            pointers[i].start = pointers[i - 1].end + space + 1
        }
        pointers.last?.end = bound // allow the last pointer to end at boundary
        
        return pointers
    }
}

class Pointer {
    var start: Int { didSet { end = start + len } }
    var end: Int
    var len: Int { didSet { end = start + len } }
    
    init(column: Cell, bound: Int) {
        start = 0
        len = column.estimateWidth(withBound: bound)
        end = start + len
    }
}
