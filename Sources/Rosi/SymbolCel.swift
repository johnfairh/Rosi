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

        // fuck me
        let sides = 16
        let angle = (Float.pi * 2) / Float(sides)
        let radius = scale * 1
        let center: SIMD2<Float> = [10, 31] * scale

        var lastPoint: SIMD2<Float> = center + [radius, 0]

        for i in 1...Int(sides) {
            let thisAngle = angle * Float(i)
            let cosA = cos(thisAngle)
            let sinA = sin(thisAngle)
            let thisPoint = center + [radius * cosA, radius * sinA]
            addLine(xPos0: lastPoint.x, yPos0: lastPoint.y, xPos1: thisPoint.x, yPos1: thisPoint.y, color: color)
            lastPoint = thisPoint
        }
    }

    var boundingBox: SIMD2<Float> {
        [20, 32] * scale // haha should calc from geometry...
    }
}
