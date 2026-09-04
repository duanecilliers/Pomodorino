import AppKit
import Carbon

// Top-level C-compatible callback for Carbon hot key events
func pomodoroHotKeyCallback(
    nextHandler: EventHandlerCallRef?,
    theEvent: EventRef?,
    userData: UnsafeMutableRawPointer?
) -> OSStatus {
    DispatchQueue.main.async {
        ShortcutManager.shared?.onToggle?()
    }
    return noErr
}

final class ShortcutManager {
    static weak var shared: ShortcutManager?

    private var hotKeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?
    var onToggle: (() -> Void)?

    deinit {
        unregister()
        if let eventHandlerRef {
            RemoveEventHandler(eventHandlerRef)
        }
    }

    @discardableResult
    func register(keyCode: Int, modifiers: Int) -> Bool {
        ShortcutManager.shared = self

        installEventHandlerIfNeeded()
        unregister()

        let hotKeyID = EventHotKeyID(
            signature: OSType(0x504F_4D4F),  // "POMO"
            id: 1
        )

        let status = RegisterEventHotKey(
            UInt32(keyCode),
            UInt32(modifiers),
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if status != noErr {
            print("Failed to register global hotkey: \(status)")
            return false
        }

        return true
    }

    func unregister() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
        }
    }

    static func carbonModifiers(from flags: NSEvent.ModifierFlags) -> Int {
        var modifiers = 0

        if flags.contains(.command) { modifiers |= Int(cmdKey) }
        if flags.contains(.option) { modifiers |= Int(optionKey) }
        if flags.contains(.control) { modifiers |= Int(controlKey) }
        if flags.contains(.shift) { modifiers |= Int(shiftKey) }

        return modifiers
    }

    static func displayString(keyCode: Int, modifiers: Int) -> String {
        var modifierSymbols = ""

        if modifiers & Int(controlKey) != 0 { modifierSymbols += "⌃" }
        if modifiers & Int(optionKey) != 0 { modifierSymbols += "⌥" }
        if modifiers & Int(shiftKey) != 0 { modifierSymbols += "⇧" }
        if modifiers & Int(cmdKey) != 0 { modifierSymbols += "⌘" }

        return modifierSymbols + (keyNames[keyCode] ?? "Key \(keyCode)")
    }

    private func installEventHandlerIfNeeded() {
        guard eventHandlerRef == nil else { return }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            pomodoroHotKeyCallback,
            1,
            &eventType,
            nil,
            &eventHandlerRef
        )

        if status != noErr {
            print("Failed to install global hotkey handler: \(status)")
        }
    }

    private static let keyNames: [Int: String] = [
        0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
        8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
        16: "Y", 17: "T", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
        23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
        31: "O", 32: "U", 34: "I", 35: "P", 36: "↩", 37: "L", 38: "J",
        40: "K", 45: "N", 46: "M", 48: "⇥", 49: "Space", 51: "⌫", 53: "⎋",
        123: "←", 124: "→", 125: "↓", 126: "↑",
    ]
}
