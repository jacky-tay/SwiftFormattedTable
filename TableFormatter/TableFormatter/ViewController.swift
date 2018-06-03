//
//  ViewController.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seperator: Character = "="
        let row = HeaderRow(cells: [
            Cell(content: "Brandy's General Store\n321 Any Street\nAnytown, NY 10121\n(212) 555-5555", alignment: .center)])
        //row.cells.first?.toString().split(separator: "\n").forEach { print($0, $0.count) }
        row.addLine(withCells: seperator.fill())
        row.addLine(withCells: "Friday, Dec 17, 2013 12:04 PM 14792 Bradley J")
        row.addLine(withCells: seperator.fill())
        
        let table = HeaderRow(cells: [Cell(content: "Hot Dog"),
                                      Cell(content: 2.25.dollar(), alignment: .right, type: .shrinkToFit)])
        table.addLine(withCells: "Egg Roll", 2.dollar())
        table.addLine(withCells: "Hot Pretzel", 1.75.dollar())
        table.addLine(withCells: "Cheese Danish", 2.99.dollar())
        table.addLine(withCells: "Jersey, Grey XL", 24.99.dollar())
        table.addLine(withCells: seperator.fill(spanCol: 2))
        table.addLine(withCells: "Item Count: 5", "Subtotal: \(33.98.dollar())")
        table.addLine(withCells: SpanColumn(content: "Sales Tax: \(0.dollar())", span: 2, alignment: .right))
        table.addLine(withCells: "", seperator.fill())
        table.addLine(withCells: "Receipt 22317", "Total: \(33.98.dollar())")
        table.addEmptyLine()
        table.addLine(withCells: "Cash: \(50.dollar())".span(col: 2, alignment: .right))
        table.addLine(withCells: "Cash: \((-16.02).dollar())".span(col: 2, alignment: .right))
        table.addEmptyLine()
        table.addLine(withCells: seperator.fill(spanCol: 2))
        table.addLine(withCells: "Thank you for Shopping at Brandy's!".span(col: 2, alignment: .center))
        
        let master = Table(bound: 48, rows: [row, table])
        textView.text = master.print().joined(separator: "\n")
        
    }
}

