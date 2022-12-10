//
//  Rosi.swift
//  Rosi
//

import MetalEngine

/// The main controller and logic for Rosi
final class Rosi {
    let engine: Engine2D
    let font: Font2D

    let symbolCel: SymbolCel

    init(engine: Engine2D) {
        self.engine = engine

        font = engine.createFont(style: .proportional, weight: .medium, height: 24)

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
    }
}
