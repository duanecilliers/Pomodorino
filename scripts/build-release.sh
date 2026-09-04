#!/usr/bin/env bash
# Build a distributable DMG with a complete ad-hoc app signature.

set -euo pipefail

APP_NAME="Pomodorino"
VERSION=$(grep -A1 "CFBundleShortVersionString" Pomodorino/Resources/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
BUILD_DIR="${BUILD_DIR:-build}"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
EXPORT_PATH="$BUILD_DIR/export"
APP_PATH="$EXPORT_PATH/$APP_NAME.app"
DMG_PATH="$BUILD_DIR/$APP_NAME-$VERSION.dmg"

echo "Building $APP_NAME v$VERSION..."

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$EXPORT_PATH"

echo "→ Creating archive..."
xcodebuild -project Pomodorino.xcodeproj \
    -scheme Pomodorino \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    archive \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    2>&1 | tail -5

echo "→ Exporting and sealing app bundle..."
cp -R "$ARCHIVE_PATH/Products/Applications/$APP_NAME.app" "$EXPORT_PATH/"

# xcodebuild leaves a linker signature on the executable when app signing is
# disabled. Re-sign the app bundle so Info.plist and resources are sealed too.
codesign --force --options runtime --sign - "$APP_PATH"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

if [[ ! -f "$APP_PATH/Contents/_CodeSignature/CodeResources" ]]; then
    echo "Error: the app bundle has no sealed resources." >&2
    exit 1
fi

echo "→ Creating DMG..."
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$EXPORT_PATH" \
    -ov -format UDZO \
    "$DMG_PATH"

echo ""
echo "✓ Build complete!"
echo "  DMG: $DMG_PATH"
echo ""
echo "The app is ad-hoc signed. macOS may require Control-click → Open on first launch."
