//
//  RosiApp.swift
//  Rosi
//

// Swift UI and AppKit gorp layer

import SwiftUI
import MetalEngine
import Dispatch

@main
struct RosiApp: App {
    init() {
        // Some nonsense to make the app work properly when run from the CLI.
        // We are before `NSApplicationMain` here so queue it.
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }

    static var instance: Rosi?

    var body: some Scene {
        WindowGroup {
            MetalEngineView() { engine in
                RosiApp.instance = Rosi(engine: engine)
            } frame: { _ in
                RosiApp.instance?.runFrame()
            }
        }
    }

    /// Hack to get text, can't quickly figure out how to manage focus in SwiftUI with an NSViewRepresentable,
    /// needs more thoughtful responder-chain management than I can spare.
    static func getText(prompt: String = "?") -> String {
        let msg = NSAlert()
        msg.alertStyle = .informational
        msg.addButton(withTitle: "OK")
        msg.messageText = prompt

        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = ""

        msg.accessoryView = txt
        msg.window.initialFirstResponder = txt
        _ = msg.runModal()
        return txt.stringValue
    }
}
