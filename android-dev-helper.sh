#!/bin/bash
# Android Development Helper Script for Doctor Throat

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
GRADLE_CMD="./gradlew"
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

# Check if Android SDK is available
check_sdk() {
  if [ -z "$ANDROID_SDK_ROOT" ]; then
    echo -e "${YELLOW}⚠ ANDROID_SDK_ROOT not set. Please configure Android SDK.${NC}"
    return 1
  fi
  echo -e "${GREEN}✓ Android SDK: $ANDROID_SDK_ROOT${NC}"
  return 0
}

# Build the app
build() {
  echo -e "${BLUE}🔨 Building Doctor Throat APK...${NC}"
  $GRADLE_CMD clean build
  echo -e "${GREEN}✓ Build successful!${NC}"
  echo -e "${BLUE}📦 APK location: $APK_PATH${NC}"
}

# Run tests
test() {
  echo -e "${BLUE}🧪 Running tests...${NC}"
  $GRADLE_CMD test
  echo -e "${GREEN}✓ Tests completed!${NC}"
}

# List connected devices
devices() {
  echo -e "${BLUE}📱 Connected devices:${NC}"
  adb devices -l
}

# Install APK on device/emulator
install() {
  if [ ! -f "$APK_PATH" ]; then
    echo -e "${YELLOW}⚠ APK not found. Building first...${NC}"
    build
  fi

  echo -e "${BLUE}📲 Installing APK...${NC}"
  adb install -r "$APK_PATH"
  echo -e "${GREEN}✓ Installation complete!${NC}"
}

# Run app on device/emulator
run() {
  install
  echo -e "${BLUE}▶ Launching app...${NC}"
  adb shell am start -n com.doctorthroat.app/.MainActivity
  echo -e "${GREEN}✓ App started!${NC}"
}

# Show device logs
logs() {
  echo -e "${BLUE}📋 Device logs (Doctor Throat):${NC}"
  adb logcat com.doctorthroat.app:V *:S
}

# Clean build artifacts
clean() {
  echo -e "${BLUE}🧹 Cleaning build artifacts...${NC}"
  $GRADLE_CMD clean
  echo -e "${GREEN}✓ Clean complete!${NC}"
}

# Start emulator
start_emulator() {
  if [ -z "$1" ]; then
    echo "Usage: $0 emulator <avd_name>"
    echo "Example: $0 emulator Pixel_4_API_30"
    return 1
  fi

  echo -e "${BLUE}🚀 Starting emulator: $1${NC}"
  emulator -avd "$1" -no-snapshot-load &
  sleep 5
  devices
}

# Show help
help() {
  cat <<EOF
${BLUE}Doctor Throat - Android Development Helper${NC}

Usage: $0 <command>

Commands:
  ${GREEN}build${NC}              - Build the APK
  ${GREEN}test${NC}               - Run unit tests
  ${GREEN}devices${NC}             - List connected devices/emulators
  ${GREEN}install${NC}             - Build and install APK on device
  ${GREEN}run${NC}                - Build, install, and launch app
  ${GREEN}logs${NC}               - Show device logs
  ${GREEN}clean${NC}              - Clean build artifacts
  ${GREEN}emulator <name>${NC}     - Start emulator by AVD name
  ${GREEN}help${NC}               - Show this help message

Environment Variables:
  ANDROID_SDK_ROOT    - Path to Android SDK
  GRADLE_OPTS         - Gradle JVM options (default: -Xmx4096m)

Examples:
  $0 build
  $0 run
  $0 emulator Pixel_5_API_31
  $0 logs

EOF
}

# Main command dispatcher
if [ $# -eq 0 ]; then
  help
  exit 0
fi

case "$1" in
  build)
    check_sdk && build
    ;;
  test)
    check_sdk && test
    ;;
  devices)
    devices
    ;;
  install)
    check_sdk && install
    ;;
  run)
    check_sdk && run
    ;;
  logs)
    logs
    ;;
  clean)
    clean
    ;;
  emulator)
    start_emulator "$2"
    ;;
  help|--help|-h)
    help
    ;;
  *)
    echo -e "${YELLOW}Unknown command: $1${NC}"
    help
    exit 1
    ;;
esac
