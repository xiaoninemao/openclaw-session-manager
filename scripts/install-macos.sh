#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="OpenClaw 会话管理器"

"$ROOT_DIR/scripts/build-macos.sh"
rm -rf "/Applications/$APP_NAME.app"
ditto "$ROOT_DIR/build/$APP_NAME.app" "/Applications/$APP_NAME.app"

echo "Installed: /Applications/$APP_NAME.app"
