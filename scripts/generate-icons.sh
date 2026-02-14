#!/bin/bash
# Generate app icons from a source 1024x1024 PNG
# Usage: ./generate-icons.sh path/to/icon-1024.png

set -e

SOURCE="$1"
ICONSET="Pomodorino/Resources/Assets.xcassets/AppIcon.appiconset"

if [ -z "$SOURCE" ]; then
    echo "Usage: $0 <source-1024x1024.png>"
    echo ""
    echo "Generate a 1024x1024 PNG with a tomato icon, then run this script."
    echo "You can create one at: https://www.figma.com or https://canva.com"
    exit 1
fi

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file not found: $SOURCE"
    exit 1
fi

echo "Generating icons from $SOURCE..."

# Generate all required sizes using sips (built into macOS)
sips -z 16 16 "$SOURCE" --out "$ICONSET/icon_16x16.png"
sips -z 32 32 "$SOURCE" --out "$ICONSET/icon_16x16@2x.png"
sips -z 32 32 "$SOURCE" --out "$ICONSET/icon_32x32.png"
sips -z 64 64 "$SOURCE" --out "$ICONSET/icon_32x32@2x.png"
sips -z 128 128 "$SOURCE" --out "$ICONSET/icon_128x128.png"
sips -z 256 256 "$SOURCE" --out "$ICONSET/icon_128x128@2x.png"
sips -z 256 256 "$SOURCE" --out "$ICONSET/icon_256x256.png"
sips -z 512 512 "$SOURCE" --out "$ICONSET/icon_256x256@2x.png"
sips -z 512 512 "$SOURCE" --out "$ICONSET/icon_512x512.png"
sips -z 1024 1024 "$SOURCE" --out "$ICONSET/icon_512x512@2x.png"

echo "✓ Icons generated in $ICONSET"
echo ""
echo "Now update Contents.json to reference the new files."
