# Android Development Setup - Doctor Throat

Complete guide for Android and cross-platform app development with Claude Code optimized environment.

## Environment Configuration

### Claude Code Settings
The project is configured with `.claude/settings.json` for optimal Android development:

**Permissions:**
- ✅ `./gradlew` and `gradle` commands
- ✅ `adb` (Android Debug Bridge) commands
- ✅ `emulator` commands
- ✅ Git operations
- ✅ Read/Write/Edit files

**Environment Variables:**
- `GRADLE_USER_HOME=.gradle` - Local gradle cache
- `ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk` - Android SDK location
- `GRADLE_OPTS=-Xmx4096m` - Gradle JVM heap size

**Hooks:**
- Post-tool hooks to notify about builds needed after Kotlin/Java/XML changes

## Prerequisites

### Required Tools
1. **Android Studio** - Latest version
2. **Android SDK** (API 34 minimum)
3. **JDK 11+** - Java Development Kit
4. **Gradle** - Included in project (./gradlew)

### Installation Steps

#### Windows
```bash
# 1. Install Android Studio from https://developer.android.com/studio

# 2. Install Android SDK in Android Studio
#    - Open SDK Manager
#    - Install API 34 SDK
#    - Install Android SDK Build Tools

# 3. Set ANDROID_SDK_ROOT environment variable
setx ANDROID_SDK_ROOT "%LOCALAPPDATA%\Android\Sdk"

# 4. Add to PATH
# C:\Android\Sdk\platform-tools (for adb)
# C:\Android\Sdk\emulator (for emulator)

# 5. Install JDK 11+
# https://adoptopenjdk.net/ or https://www.oracle.com/java/technologies/downloads/
```

#### macOS
```bash
# 1. Install Android Studio
brew install --cask android-studio

# 2. Install Android SDK via Android Studio

# 3. Set environment variable
echo 'export ANDROID_SDK_ROOT=~/Library/Android/sdk' >> ~/.zshrc
source ~/.zshrc

# 4. Install JDK
brew install openjdk@11
```

#### Linux
```bash
# 1. Download Android Studio from developer.android.com

# 2. Install Android SDK

# 3. Set environment variable
echo 'export ANDROID_SDK_ROOT=~/Android/Sdk' >> ~/.bashrc
source ~/.bashrc

# 4. Install JDK
sudo apt install openjdk-11-jdk
```

## Helper Scripts

### Windows
```bash
# Build the app
.\android-dev-helper.bat build

# Run all tests
.\android-dev-helper.bat test

# List connected devices
.\android-dev-helper.bat devices

# Build, install, and run on device
.\android-dev-helper.bat run

# View device logs
.\android-dev-helper.bat logs

# Start emulator
.\android-dev-helper.bat emulator Pixel_5_API_31

# Clean build
.\android-dev-helper.bat clean
```

### macOS/Linux
```bash
# Make script executable
chmod +x android-dev-helper.sh

# Build the app
./android-dev-helper.sh build

# Run all tests
./android-dev-helper.sh test

# List connected devices
./android-dev-helper.sh devices

# Build, install, and run on device
./android-dev-helper.sh run

# View device logs
./android-dev-helper.sh logs

# Start emulator
./android-dev-helper.sh emulator Pixel_5_API_31

# Clean build
./android-dev-helper.sh clean
```

## Direct Gradle Commands

### Build & Package
```bash
# Clean and build
./gradlew clean build

# Build debug APK only
./gradlew assembleDebug

# Build release APK (requires signing)
./gradlew assembleRelease

# Build and install on device
./gradlew installDebug

# Refresh dependencies
./gradlew --refresh-dependencies build
```

### Testing
```bash
# Run all unit tests
./gradlew test

# Run tests for specific module
./gradlew :app:test

# Run tests with verbose output
./gradlew test --info

# Run instrumented tests on device
./gradlew connectedAndroidTest
```

### Development
```bash
# Run with specific build variant
./gradlew runDebug

# Build without optimization (faster for dev)
./gradlew assembleDebug

# Check dependencies
./gradlew dependencies

# Check for updates
./gradlew dependencyUpdates
```

## ADB Commands

### Device Management
```bash
# List all connected devices
adb devices

# List devices with detailed info
adb devices -l

# Get device model and SDK version
adb shell getprop ro.product.model
adb shell getprop ro.build.version.sdk

# Reboot device
adb reboot

# Reboot to bootloader
adb reboot bootloader
```

### App Installation
```bash
# Install APK
adb install app/build/outputs/apk/debug/app-debug.apk

# Install with replacement
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Uninstall app
adb uninstall com.doctorthroat.app

# Clear app data
adb shell pm clear com.doctorthroat.app
```

### App Control
```bash
# Start app
adb shell am start -n com.doctorthroat.app/.MainActivity

# Stop app
adb shell am force-stop com.doctorthroat.app

# Get running processes
adb shell ps | grep doctorthroat

# Get installed packages
adb shell pm list packages | grep doctorthroat
```

### Debugging & Logging
```bash
# View logs (all)
adb logcat

# View logs (app only)
adb logcat com.doctorthroat.app:V *:S

# View logs (errors only)
adb logcat *:E

# Clear log buffer
adb logcat -c

# Save logs to file
adb logcat > device.log

# View system logs
adb shell dumpsys meminfo com.doctorthroat.app
```

### File Management
```bash
# Push file to device
adb push local_file /data/local/tmp/remote_file

# Pull file from device
adb pull /data/local/tmp/remote_file local_file

# Browse device files
adb shell

# List files
adb shell ls -la /data/data/com.doctorthroat.app/
```

## Emulator

### Create Emulator
```bash
# List available emulators
emulator -list-avds

# Create new emulator
avdmanager create avd -n Pixel_5_API_31 -k "system-images;android-31;google_apis;x86_64" -d "Pixel 5"

# Create with specific options
avdmanager create avd -n test_device -k "system-images;android-34;google_apis;arm64-v8a"
```

### Run Emulator
```bash
# Start emulator
emulator -avd Pixel_5_API_31

# Start without snapshot
emulator -avd Pixel_5_API_31 -no-snapshot-load

# Start with GPU acceleration
emulator -avd Pixel_5_API_31 -gpu on

# Start with reduced memory
emulator -avd Pixel_5_API_31 -memory 2048

# Start with network disabled
emulator -avd Pixel_5_API_31 -netspeed gsm
```

## Development Workflow

### Typical Development Cycle
```bash
# 1. Make code changes in Android Studio or editor

# 2. Build the project
./gradlew build

# 3. Run tests
./gradlew test

# 4. Install on device/emulator
./gradlew installDebug

# 5. Run the app
adb shell am start -n com.doctorthroat.app/.MainActivity

# 6. View logs
adb logcat com.doctorthroat.app:V *:S
```

### Using the Helper Script
```bash
# One command does it all
./android-dev-helper.bat run

# Or on macOS/Linux
./android-dev-helper.sh run
```

## Performance Tips

### Gradle Build Speed
```gradle
# In app/build.gradle.kts, add:
android {
    buildFeatures {
        compose = true
        viewBinding = false  # Disable if not using
    }

    # Enable build cache
    buildCache {
        local {
            enabled = true
        }
    }
}
```

### Development Setup
- Use **incremental builds**: Gradle caches unchanged code
- Enable **file watching**: Auto-reload in emulator
- Use **instant run**: For faster iterations (Android Studio)
- Run **headless emulator**: For faster startup

## Cross-Platform Development

### Kotlin Multiplatform
For cross-platform Android + iOS, consider Kotlin Multiplatform Mobile (KMM):
```bash
# Create KMM project
mkdir MyApp
cd MyApp
# Use Android Studio > File > New > Kotlin Multiplatform App
```

### Flutter (Alternative)
If planning cross-platform Flutter apps:
```bash
# Install Flutter
flutter create --platforms=android,ios my_app

# Run on Android
flutter run
```

### React Native (Alternative)
```bash
# Create React Native project
npx react-native init DoctorThroat

# Run Android
npx react-native run-android
```

## Troubleshooting

### Common Issues

**"adb: command not found"**
- Add `$ANDROID_SDK_ROOT/platform-tools` to PATH
- Restart terminal

**"ANDROID_SDK_ROOT not set"**
```bash
# Windows
setx ANDROID_SDK_ROOT "%LOCALAPPDATA%\Android\Sdk"

# macOS/Linux
export ANDROID_SDK_ROOT=~/Library/Android/sdk  # macOS
export ANDROID_SDK_ROOT=~/Android/Sdk         # Linux
```

**"No connected devices"**
- Check USB cable connection
- Enable USB debugging on device
- Try: `adb kill-server && adb start-server`

**"Gradle build fails"**
```bash
# Clean and rebuild
./gradlew clean build --info

# Clear gradle cache
rm -rf ~/.gradle/caches

# Check JDK version
java -version
```

**"Emulator won't start"**
- Ensure virtualization is enabled in BIOS
- Try: `emulator -avd <name> -no-snapshot-load`
- Increase allocated memory/disk

## Resources

- [Android Developer Docs](https://developer.android.com/docs)
- [Kotlin Documentation](https://kotlinlang.org/docs)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
- [Android Studio User Guide](https://developer.android.com/studio/intro)
- [Gradle Documentation](https://gradle.org/documentation/)
- [CameraX Library](https://developer.android.com/training/camerax)

## Next Steps

1. ✅ Install Android Studio and SDK
2. ✅ Set ANDROID_SDK_ROOT environment variable
3. ✅ Connect a device or start an emulator
4. ✅ Run `./gradlew build` to verify setup
5. ✅ Use `./android-dev-helper run` to build and run the app
6. ✅ Start developing with Claude Code assistance

## Quick Start Command

```bash
# One command to build, install, and run
./android-dev-helper.bat run
# or
./android-dev-helper.sh run
```

---

**Happy coding!** 🚀 Ask Claude Code for help with Android development tasks.
