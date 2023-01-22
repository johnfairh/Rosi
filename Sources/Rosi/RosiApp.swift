//
//  RosiApp.swift
//  Rosi
//

// Swift UI and AppKit gorp layer

import SwiftUI
import MetalEngine

@main
struct RosiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
    static func getText(prompt: String = "?", current: String = "") -> String {
        let msg = NSAlert()
        msg.alertStyle = .informational
        msg.addButton(withTitle: "OK")
        msg.messageText = prompt

        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = current

        msg.accessoryView = txt
        msg.window.initialFirstResponder = txt
        _ = msg.runModal()
        return txt.stringValue
    }
}

/// Get the app working properly when `swift run`
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
}
