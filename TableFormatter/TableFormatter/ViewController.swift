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
        let row = HeaderRow(cells: [Cell(content: "Brandy's General Store", alignment: .center)])
        row.addLine(withCells: "321 Any Street")
        row.addLine(withCells: "Anytown, NY 10121")
        row.addLine(withCells: "(212) 555-5555")
        row.addLine(withCells: "Friday, Dec 17, 2013 12:04 PM 14792 Bradley J")
        
        let table = HeaderRow(cells: [Cell(content: "Hot Dog"),
                                      Cell(content: 2.25.dollar(), alignment: .right)])
        table.addLine(withCells: "Egg Roll", 2.dollar())
        table.addLine(withCells: "Hot Pretzel", 1.75.dollar())
        table.addLine(withCells: "Cheese Danish", 2.99.dollar())
        table.addLine(withCells: "Jersey, Grey XL", 24.99.dollar())
        table.addLine(withCells: FillableSpanColumn(char: "=", span: 2))
        table.addLine(withCells: "Item Count: 5", "Subtotal: \(33.98.dollar())")
        table.addLine(withCells: SpanColumn(content: "Sales Tax: \(0.dollar())", span: 2, alignment: .right))
        table.addLine(withCells: "Receipt 22317", "Total: \(33.98.dollar())")
        
        let master = Table(bound: 20, rows: [row, table])
        textView.text = master.print().joined(separator: "\n")

    }
}

