//
//  SpanColumn.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

protocol Spannable {
    var span: Int! { get set }
    var alignment: Alignment { get set }
}

struct SpanColumn: InstanceCell, Spannable {
    var content: String!
    var span: Int!
    var alignment: Alignment = .center
    
    func toString() -> String {
        return content
    }
}
