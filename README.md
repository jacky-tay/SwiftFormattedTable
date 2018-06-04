# SwiftFormattedTable
A formatter for monospace font printing

## Background
One of the iOS app I've built is required to build a table formatter which can print receipt for a thermal printer. The printer has a fixed character length, it prints monospace font, and it accepts text only.

This demo is a refactor modification, since the previous code is private.

## Example
![original](http://www.accupos.com/wp-content/uploads/2015/11/AccuPOS-Retail-Receipt-Example.jpg)
![demo](https://github.com/jacky-tay/SwiftFormattedTable/blob/master/Assets/demo.png)

The receipt can be constructed as follow:

```
let seperator: Character = "="
let row = HeaderRow(cells: [
    Cell(content: "Brandy's General Store\n321 Any Street\nAnytown, NY 10121\n(212) 555-5555", alignment: .center)])
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
table.addLine(withCells: "Sales Tax: \(0.dollar())".span(col: 2, alignment: .right))
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
```

## Requirements
* Minimum iOS version: 11.3
* XCode 9.4
* Swift 4.1

## Author
Jacky Tay - Software Developer - [Smudge](http://www.smudgeapps.com/)

## License
SwiftStickyHeaderTableView is available under the MIT license. See the [LICENSE](https://github.com/jacky-tay/SwiftFormattedTable/blob/master/LICENSE) file for more info.
