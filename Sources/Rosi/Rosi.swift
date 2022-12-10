//
//  Rosi.swift
//  Rosi
//

import MetalEngine

/// The main controller and logic for Rosi
final class Rosi {
    let engine: Engine2D
    let font: Font2D
    let font2: Font2D

    let symbolCel: SymbolCel

    init(engine: Engine2D) {
        self.engine = engine

        font = engine.createFont(style: .proportional, weight: .medium, height: 24)
        font2 = engine.createFont(style: .proportional, weight: .medium, height: 10)

        symbolCel = SymbolCel(engine: engine, color: .rgb(0.9, 0.9, 0.9), scale: 10)
        symbolCel.pos = [10, 10]
    }

    func runFrame() {
        symbolCel.render()
        let texts = "One [foo]\nTwo\nThree (p28)"

        let screen = engine.viewportSize
        let textWidth = screen.x - 10 - symbolCel.boundingBox.x - 10 - 10
        let textX = screen.x - 10 - textWidth
        let textHeight = screen.y - 10 - 10 - 10
        let textY = Float(10)

        engine.drawText(texts, font: font, color: .rgb(0.9, 0.9, 0.9),
                        x: textX, y: textY, width: textWidth, height: textHeight,
                        align: .left, valign: .center)

        let index = 105
        engine.drawText("\(index)", font: font, color: .rgb(0.9, 0.9, 0.9),
                        x: textX, y: textY, width: textWidth, height: textHeight + 10,
                        align: .right, valign: .bottom)

        let instructions = "1-7, a-f, ., tuv"
        engine.drawText(instructions, font: font2, color: .rgb(0.9, 0.9, 0.9),
                        x: textX, y: textY, width: textWidth, height: textHeight + 10,
                        align: .right, valign: .top)
        handleKeys()
    }

    func handleKeys() {
        // maintain symbol (always set) & symboldata (can be nil)
        //
        // ** get stroke keypress **
        // call toggle on symbol.stroke (our local struct)
        // set symbol.stroke into symbolcel
        //
        // look up new symbol in db
        // if found, update symboldata (source of text)
        // if not found, symboldata = nil
        //
        // ** get text keypress **
        // if symboldata nil, allocate it and assign ID
        // get new text from alert hack
        // update symboldata
        // update DB with symbol + symboldata -- in memory and save it
    }
}
