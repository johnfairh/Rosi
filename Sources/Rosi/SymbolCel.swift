//
//  SymbolEntity.swift
//  Rosi
//

import MetalEngine
import simd

/// A view of a Tunic symbol
/// Position is top-left, size is fixed [pass in scale!]
/// So right now this is the definition of what each stroke bit actually means!
final class SymbolCel: VectorEntity {
    let color: Color2D

    /// Variable geometry
    let strokes: [(SIMD2<Float>, SIMD2<Float>)] = [
        ([10, 0], [0, 6]),      // 1 - NW
        ([20, 6], [10, 0]),     // 2 - NE
        ([0, 6], [10, 12]),     // 3 - SW
        ([10, 0], [10, 12]),    // 4 - top vert
        ([10, 12], [20, 6]),    // 5 - SE
        ([0, 6], [0, 17]),      // 6 - left vert
        ([10, 17], [10, 12]),   // 7 - mid vert

        ([0, 18], [0, 24]),     // 8(a) - left vert
        ([0, 24], [10, 18]),    // 9(b) - NW
        ([10, 18], [20, 24]),   // 10(c) - NE
        ([10, 30], [0, 24]),    // 11(d) - SW
        ([10, 18], [10, 30]),   // 12(e) - mid vert
        ([20, 24], [10, 30]),   // 13(f) - SE
    ]
    // Plus order diacritic, handled separately

    static let ORDER_DIACRITIC_STROKE = Symbol.STROKE_COUNT - 1

    /// Fixed geometry
    let always: [(SIMD2<Float>, SIMD2<Float>)] = [
        ([0,17], [20, 17])
    ]

    let scale: Float

    var boundingBox: SIMD2<Float> {
        [20, 32] * scale // should calc from geometry...
    }

    init(engine: Engine2D, color: Color2D, scale: Float) {
        precondition(strokes.count == Symbol.STROKE_COUNT - 1)
        self.color = color
        self.scale = scale

        super.init(engine: engine, collisionRadius: 0)
    }

    /// Cache current symbol, when it changes update the geometry
    private var symbol: Symbol?

    func set(symbol: Symbol) {
        guard symbol != self.symbol else {
            return
        }
        self.symbol = symbol

        clearVertexes()
        always.forEach { add(line: $0) }
        for stroke in 0..<strokes.count {
            if symbol.has(stroke: stroke) {
                add(line: strokes[stroke])
            }
        }
        if symbol.has(stroke: SymbolCel.ORDER_DIACRITIC_STROKE) {
            addCircle(center: [10, 31] * scale, radius: 1 * scale, color: color)
        }
    }

    /// Hit-tester for clicking strokes
    func getStrokeClick() -> Int? {
        guard let clickPos = engine.getMouseClick() else {
            return nil
        }
        // normalize click to unscaled coords
        let pos = (clickPos - pos) / scale

        for s in 0..<strokes.count {
            if pos.closenessTo(line: strokes[s]) < 2 {
                return s
            }
        }
        // hard-code the order diacritic
        if pos.y > 30 {
            return SymbolCel.ORDER_DIACRITIC_STROKE
        }
        return nil
    }

    /// Helper
    func add(line: (SIMD2<Float>, SIMD2<Float>)) {
        let from = line.0 * scale
        let to = line.1 * scale
        addLine(xPos0: from.x, yPos0: from.y, xPos1: to.x, yPos1: to.y, color: color)
    }
}

extension SIMD2<Float> {
    // Learnt a lot about how not to model this kind of thing!! Yikes.
    func closenessTo(line: (Self, Self)) -> Scalar {
        let maxY, minY: Float
        if line.0.y > line.1.y {
            maxY = line.0.y; minY = line.1.y
        } else {
            maxY = line.1.y; minY = line.0.y
        }
        guard y >= minY && y <= maxY else {
            return 100
        }
        let num = abs((line.1.x - line.0.x)*(line.0.y - y) -
                      (line.0.x - x)*(line.1.y - line.0.y))
        let denom = simd_distance(line.0, line.1)
        return num / denom
    }
}
