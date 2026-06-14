#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="OpenClaw 会话管理器"
BUILD_DIR="$ROOT_DIR/build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
ICONSET_DIR="$BUILD_DIR/OpenClaw.iconset"

rm -rf "$APP_DIR" "$ICONSET_DIR"
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources/app/public"
mkdir -p "$ICONSET_DIR"

xcrun swiftc "$ROOT_DIR/macos/AppMain.swift" \
  -o "$APP_DIR/Contents/MacOS/OpenClawSessionManager" \
  -framework AppKit \
  -framework WebKit

cp "$ROOT_DIR/macos/Info.plist" "$APP_DIR/Contents/Info.plist"
cp "$ROOT_DIR/server.mjs" "$ROOT_DIR/package.json" "$APP_DIR/Contents/Resources/app/"
cp "$ROOT_DIR"/public/* "$APP_DIR/Contents/Resources/app/public/"
printf 'APPL????' > "$APP_DIR/Contents/PkgInfo"

SOURCE_ICON="$BUILD_DIR/openclaw-logo.png"
qlmanage -t -s 1024 -o "$BUILD_DIR" "$ROOT_DIR/public/openclaw-logo.svg" >/dev/null 2>&1
mv "$BUILD_DIR/openclaw-logo.svg.png" "$SOURCE_ICON"

sips -z 16 16 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null
sips -z 64 64 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null
sips -z 1024 1024 "$SOURCE_ICON" --out "$ICONSET_DIR/icon_512x512@2x.png" >/dev/null
iconutil -c icns "$ICONSET_DIR" -o "$APP_DIR/Contents/Resources/OpenClaw.icns"

xattr -cr "$APP_DIR"
codesign --force --deep --sign - "$APP_DIR"
codesign --verify --deep --strict "$APP_DIR"

echo "Built: $APP_DIR"
