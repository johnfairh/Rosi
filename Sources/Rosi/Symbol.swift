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

struct SymbolData: Codable {
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

import Foundation

extension SymbolTable {
    static var dbDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser
    }

    static var dbURL: URL {
        dbDirectory.appendingPathComponent("rosi.json")
    }

    static var dbBackupURL: URL {
        dbDirectory.appendingPathComponent("rosi.backup.json")
    }

    static func load() -> (SymbolTable, Int) {
        do {
            try? FileManager.default.removeItem(at: dbBackupURL)
            try FileManager.default.copyItem(at: dbURL, to: dbBackupURL)
        } catch {
            print("Couldn't back up symbols: \(error)")
        }

        do {
            let json = try Data(contentsOf: dbURL)
            let decoder = JSONDecoder()
            let symbols = try decoder.decode(SymbolTable.self, from: json)
            print("Restored \(symbols.count) symbols")
            return (symbols, symbols.count + 1)
        } catch {
            print("Couldn't restore symbols: \(error)")
            return ([:], 1)
        }
    }

    func save() {
        let encoder = JSONEncoder()
        let json = try! encoder.encode(self)
        try! json.write(to: Self.dbURL)
        print("Wrote \(self.count) symbols")
    }
}
