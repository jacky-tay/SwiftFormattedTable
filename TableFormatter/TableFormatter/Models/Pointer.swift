//
//  Pointer.swift
//  TableFormatter
//
//  Created by Jacky Tay on 4/06/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

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
