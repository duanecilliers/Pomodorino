#!/usr/bin/env swift
// Generates a simple tomato app icon using emoji
// Run: swift scripts/create-icon.swift

import Cocoa

let size: CGFloat = 1024
let emoji = "🍅"

// Create image
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()

// Draw gradient background
let gradient = NSGradient(colors: [
    NSColor(red: 0.98, green: 0.95, blue: 0.90, alpha: 1.0),
    NSColor(red: 0.95, green: 0.90, blue: 0.85, alpha: 1.0)
])!
gradient.draw(in: NSRect(x: 0, y: 0, width: size, height: size), angle: -45)

// Draw rounded rect background
let bgRect = NSRect(x: size * 0.08, y: size * 0.08, width: size * 0.84, height: size * 0.84)
let bgPath = NSBezierPath(roundedRect: bgRect, xRadius: size * 0.18, yRadius: size * 0.18)
NSColor(red: 1.0, green: 0.98, blue: 0.96, alpha: 1.0).setFill()
bgPath.fill()

// Draw subtle shadow
let shadowRect = bgRect.offsetBy(dx: 0, dy: -size * 0.02)
let shadowPath = NSBezierPath(roundedRect: shadowRect, xRadius: size * 0.18, yRadius: size * 0.18)
NSColor(red: 0, green: 0, blue: 0, alpha: 0.08).setFill()
shadowPath.fill()
bgPath.fill() // redraw main rect on top

// Draw emoji
let font = NSFont.systemFont(ofSize: size * 0.55)
let attributes: [NSAttributedString.Key: Any] = [
    .font: font
]
let emojiSize = (emoji as NSString).size(withAttributes: attributes)
let point = NSPoint(
    x: (size - emojiSize.width) / 2,
    y: (size - emojiSize.height) / 2 - size * 0.02
)
(emoji as NSString).draw(at: point, withAttributes: attributes)

image.unlockFocus()

// Save as PNG
guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:]) else {
    print("Error: Failed to create image")
    exit(1)
}

let outputPath = "icon-1024.png"
do {
    try pngData.write(to: URL(fileURLWithPath: outputPath))
    print("✓ Created \(outputPath)")
    print("  Run: ./scripts/generate-icons.sh \(outputPath)")
} catch {
    print("Error: \(error)")
    exit(1)
}
