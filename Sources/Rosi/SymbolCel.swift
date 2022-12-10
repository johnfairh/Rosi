//
//  SymbolEntity.swift
//  Rosi
//

import MetalEngine
import simd

/// A view of a Tunic symbol
/// Position is top-left, size is fixed [pass in scale!]
final class SymbolCel: VectorEntity {
    let color: Color2D

    let points: [(SIMD2<Float>, SIMD2<Float>)] = [
        // top
        ([0, 6], [0, 17]),
        ([0, 17], [10, 17]),
        ([10, 17], [10, 12]),
        ([10, 12], [20, 6]),
        ([20, 6], [10, 0]),
        ([10, 0], [0, 6]),
        ([0, 6], [10, 12]),
        ([10, 0], [10, 12]),
        // mid
        ([0,17], [20, 17]),
        // bot
        ([0, 18], [0, 24]),
        ([0, 24], [10, 18]),
        ([10, 18], [20, 24]),
        ([20, 24], [10, 30]),
        ([10, 30], [0, 24]),
        ([10, 18], [10, 30])
    ]

    let scale: Float

    init(engine: Engine2D, color: Color2D, scale: Float) {
        self.color = color
        self.scale = scale

        super.init(engine: engine, collisionRadius: 0)

        points.forEach { point in
            let from = point.0 * scale
            let to = point.1 * scale
            addLine(xPos0: from.x, yPos0: from.y, xPos1: to.x, yPos1: to.y, color: color)
        }

        addCircle(center: [10, 31] * scale, radius: 1 * scale, color: color)
    }

    var boundingBox: SIMD2<Float> {
        [20, 32] * scale // haha should calc from geometry...
    }
}
