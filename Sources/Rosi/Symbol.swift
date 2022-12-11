//
//  Symbol.swift
//  Rosi
//

/// Model object for symbols
struct Symbol: Codable, Hashable {
    private var strokes: UInt16

    static let STROKE_COUNT = 14

    init() {
        strokes = 0
    }

    func has(stroke: Int) -> Bool {
        precondition(stroke < Self.STROKE_COUNT)
        return (strokes & (1<<stroke)) != 0
    }

    mutating func toggle(stroke: Int) {
        precondition(stroke < Self.STROKE_COUNT)
        strokes = strokes ^ (1<<stroke)
    }
}

struct SymbolData {
    let id: Int
    private(set) var text: [String]

    static let TEXT_COUNT = 3

    init(id: Int) {
        self.id = id
        text = .init(repeating: "", count: Self.TEXT_COUNT)
    }

    mutating func set(textId: Int, to text: String) {
        precondition(textId < Self.TEXT_COUNT)
        self.text[textId] = text
    }
}

typealias SymbolTable = Dictionary<Symbol, SymbolData>

extension SymbolTable {
    static func load() -> (SymbolTable, Int) {
        return ([:], 1)
    }

    static func save() {
        // ...
    }
}
