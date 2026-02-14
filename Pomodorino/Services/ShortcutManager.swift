import Carbon
import AppKit

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

class ShortcutManager {
    static weak var shared: ShortcutManager?

    private var hotKeyRef: EventHotKeyRef?
    var onToggle: (() -> Void)?

    func register() {
        ShortcutManager.shared = self

        let hotKeyID = EventHotKeyID(
            signature: OSType(0x504F_4D4F),  // "POMO"
            id: 1
        )

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetApplicationEventTarget(),
            pomodoroHotKeyCallback,
            1,
            &eventType,
            nil,
            nil
        )

        // Control + Option + P (keyCode 35)
        let status = RegisterEventHotKey(
            35,
            UInt32(controlKey | optionKey),
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if status != noErr {
            print("Failed to register global hotkey: \(status)")
        }
    }

    func unregister() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
        }
    }
}
