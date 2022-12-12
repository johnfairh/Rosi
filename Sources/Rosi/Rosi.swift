//
//  Rosi.swift
//  Rosi
//

import MetalEngine

extension Color2D {
    static let foreground = Color2D(r: 0.9, g: 0.9, b: 0.9, a: 1)
    static let background = Color2D(r: 0.3, g: 0.3, b: 0.3, a: 1)
}

/// The main controller and logic for Rosi
final class Rosi {
    let engine: Engine2D
    let font: Font2D
    let font2: Font2D
    let symbolCel: SymbolCel
    private var keySampler: KeySampler

    private var symbolTable: SymbolTable
    private var nextSymbolID: Int

    private var currentSymbol: Symbol
    private var currentSymbolData: SymbolData?

    init(engine: Engine2D) {
        self.engine = engine
        self.keySampler = KeySampler(engine: engine)
        engine.setBackgroundColor(.background)

        font = engine.createFont(style: .proportional, weight: .medium, height: 24)
        font2 = engine.createFont(style: .proportional, weight: .medium, height: 10)

        symbolCel = SymbolCel(engine: engine, color: .foreground, scale: 10)
        symbolCel.pos = [10, 10]

        (symbolTable, nextSymbolID) = SymbolTable.load()

        currentSymbol = Symbol()
        currentSymbolData = nil
    }

    func runFrame() {
        // get mouse symbol event from symbolCel
        handleKeys() // get key input and update state
        symbolCel.set(symbol: currentSymbol) // propagate updated state
        render() // draw it
    }

    func handleKeys() {
        // ** get stroke keypress **
        // call toggle on symbol.stroke (our local struct)
        // set symbol.stroke into symbolcel
        //
        // look up new symbol in db
        // if found, update symboldata (source of text)
        // if not found, symboldata = nil
        //
        // ** get text keypress **

        if handleTextKeys() {
            // update DB with symbol + symboldata -- in memory and save it
            symbolTable.save()
        }
    }

    /// Text-setting
    func handleTextKeys() -> Bool {
        let textKeys = ["T", "U", "V"].map { VirtualKey.printable($0) }

        for k in 0..<textKeys.count {
            guard keySampler.isKeyDown(textKeys[k]) else {
                continue
            }
            // if symboldata nil, allocate it and assign ID
            if currentSymbolData == nil {
                currentSymbolData = SymbolData(id: nextSymbolID)
                nextSymbolID += 1
            }
            currentSymbolData!.set(textId: k, to: RosiApp.getText(prompt: "Text \(k+1)"))
            symbolTable[currentSymbol] = currentSymbolData!
            return true
        }
        return false
    }

    func render() {
        symbolCel.render()

        let screen = engine.viewportSize
        let textWidth = screen.x - 10 - symbolCel.boundingBox.x - 10 - 10
        let textX = screen.x - 10 - textWidth
        let textHeight = screen.y - 10 - 10 - 10
        let textY = Float(10)

        if let texts = currentSymbolData?.text.joined(separator: "\n"),
           !texts.isEmpty {
            engine.drawText(texts, font: font, color: .foreground,
                            x: textX, y: textY, width: textWidth, height: textHeight,
                            align: .left, valign: .center)
        }

        let index = currentSymbolData?.id.description ?? "?"
        engine.drawText(index, font: font, color: .foreground,
                        x: textX, y: textY, width: textWidth, height: textHeight + 10,
                        align: .right, valign: .bottom)

        let instructions = "1-7, a-f, ., tuv"
        engine.drawText(instructions, font: font2, color: .foreground,
                        x: textX, y: textY, width: textWidth, height: textHeight + 10,
                        align: .right, valign: .top)
    }

}

/// Helper to debounce keypress events
struct KeySampler {
    let engine: Engine2D
    let debounce: TickSource.TickCount
    private var keys: [VirtualKey: TickSource.TickCount]

    /// Wrap a predicate so it returns `true` only once every `debounce` milliseconds
    init(engine: Engine2D, debounce: TickSource.TickCount = 250) {
        self.engine = engine
        self.debounce = debounce
        self.keys = [:]
    }

    mutating func isKeyDown(_ key: VirtualKey) -> Bool {
        let now = engine.currentTickCount

        if let lastTime = keys[key],
           now.isShorterThan(debounce, since: lastTime) {
            // don't care if actually down
            return false
        }

        guard engine.isKeyDown(key) else {
            keys[key] = nil
            return false
        }

        keys[key] = now
        return true
    }
}
