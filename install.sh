#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

APP_NAME="Pomodorino"
SCHEME="Pomodorino"
CONFIG="Release"

if ! command -v xcodebuild &>/dev/null; then
  echo -e "${RED}Error: xcodebuild not found. Please install Xcode or Xcode Command Line Tools.${NC}"
  exit 1
fi

echo -e "${BLUE}Building ${APP_NAME}...${NC}"

BUILD_LOG=$(mktemp)
if ! xcodebuild \
  -project "${APP_NAME}.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -derivedDataPath build \
  > "$BUILD_LOG" 2>&1; then
  echo -e "${RED}Build failed. Last 20 lines of log:${NC}"
  tail -20 "$BUILD_LOG"
  rm -f "$BUILD_LOG"
  exit 1
fi
rm -f "$BUILD_LOG"

APP_PATH="build/Build/Products/${CONFIG}/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
  echo -e "${RED}Build failed. App not found.${NC}"
  exit 1
fi

if [ -d "/Applications/${APP_NAME}.app" ]; then
  echo -e "${YELLOW}Removing old installation...${NC}"
  rm -rf "/Applications/${APP_NAME}.app"
fi

echo -e "${BLUE}Copying to /Applications...${NC}"
cp -R "$APP_PATH" /Applications/

echo -e "${YELLOW}Ad-hoc signing...${NC}"
codesign --deep --force --options runtime --sign - "/Applications/${APP_NAME}.app"

echo -e "${YELLOW}Removing quarantine flag...${NC}"
xattr -dr com.apple.quarantine "/Applications/${APP_NAME}.app" 2>/dev/null || true

echo -e "${BLUE}Cleaning up build artifacts...${NC}"
rm -rf build

echo -e "${GREEN}Installed successfully.${NC}"
echo -e "${GREEN}You can now open ${APP_NAME} from Applications.${NC}"
