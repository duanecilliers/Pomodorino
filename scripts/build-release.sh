#!/bin/bash
# Build Pomodorino for release distribution
# Creates a DMG file for GitHub Releases

set -e

APP_NAME="Pomodorino"
VERSION=$(grep -A1 "CFBundleShortVersionString" Pomodorino/Resources/Info.plist | tail -1 | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
EXPORT_PATH="$BUILD_DIR/export"
DMG_PATH="$BUILD_DIR/$APP_NAME-$VERSION.dmg"

echo "Building $APP_NAME v$VERSION..."
echo ""

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build archive
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

# Export app
echo "→ Exporting app..."
mkdir -p "$EXPORT_PATH"
cp -R "$ARCHIVE_PATH/Products/Applications/$APP_NAME.app" "$EXPORT_PATH/"

# Create DMG
echo "→ Creating DMG..."
hdiutil create -volname "$APP_NAME" \
    -srcfolder "$EXPORT_PATH" \
    -ov -format UDZO \
    "$DMG_PATH"

echo ""
echo "✓ Build complete!"
echo "  DMG: $DMG_PATH"
echo ""
echo "To create a GitHub release:"
echo "  1. git tag v$VERSION"
echo "  2. git push origin v$VERSION"
echo "  3. gh release create v$VERSION $DMG_PATH --title \"v$VERSION\" --notes \"Initial release\""
