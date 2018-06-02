//
//  FillColumn.swift
//  TableFormatter
//
//  Created by Jacky Tay on 1/06/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

protocol Fillable {
    var char: Character! { get set }
}

struct FillColumn: InstanceCell, Fillable {
    var char: Character!
    
    func toString() -> String {
        return ""
    }
}

struct FillableSpanColumn: InstanceCell, Fillable, Spannable {
    var char: Character!
    var span: Int!
    var alignment: Alignment = .center
    
    init(char: Character, span: Int) {
        self.char = char
        self.span = span
    }
    
    func toString() -> String {
        return ""
    }
}
