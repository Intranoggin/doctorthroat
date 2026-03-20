# Doctor Throat - Android App

A simple Android app that uses your phone's camera and flashlight to help check someone's throat. Perfect for quick visual examinations when you need to see down someone's throat with proper lighting.

## Features

- 📷 **Camera Preview** - Full-screen camera view for examining
- 🔦 **Flashlight Control** - One-tap button to turn the phone's flashlight on/off
- 🎨 **Simple Dark UI** - Easy on the eyes, optimized for examining throats
- 📱 **Modern Jetpack Compose** - Built with Android's latest UI toolkit

## Permissions Required

- **CAMERA** - To access the phone's camera
- **FLASHLIGHT** - To control the phone's flashlight/torch

The app will request these permissions on first launch.

## How to Use

1. **Open the App** - Launch Doctor Throat on your Android device
2. **Grant Permissions** - Allow camera and flashlight access when prompted
3. **Turn On Flashlight** - Tap the big yellow button to activate the flashlight
4. **Examine Throat** - Position the phone in front of the throat area, use the camera to see the area clearly with the bright light
5. **Turn Off Flashlight** - Tap the button again to turn off the flashlight when done

## Requirements

- **Android 9.0+** (API level 28+)
- Device with camera and flashlight
- Camera and flashlight permissions granted

## Building the App

### Prerequisites
- Android Studio (latest version)
- Android SDK (API level 34)
- Kotlin 1.9.0+

### Steps

1. **Clone or open the project in Android Studio**
   ```bash
   git clone <repo-url>
   cd DoctorThroat
   ```

2. **Open in Android Studio**
   - File → Open → Select the DoctorThroat folder

3. **Build the project**
   - Build → Make Project (or Ctrl+F9)

4. **Run on device/emulator**
   - Run → Run 'app' (or Shift+F10)
   - Select your target device

### Or build from command line

```bash
./gradlew build              # Build the APK
./gradlew installDebug       # Install on connected device
```

## Project Structure

```
DoctorThroat/
├── app/
│   ├── build.gradle.kts          # App-level build configuration
│   ├── src/main/
│   │   ├── AndroidManifest.xml   # App manifest with permissions
│   │   ├── java/com/doctorthroat/app/
│   │   │   └── MainActivity.kt   # Main app logic and UI
│   │   └── res/
│   │       └── values/
│   │           ├── strings.xml   # String resources
│   │           └── styles.xml    # App themes
│   └── ...
├── build.gradle.kts              # Root build configuration
├── settings.gradle.kts           # Project settings
└── README.md                      # This file
```

## Technical Details

### Dependencies
- **Jetpack Compose** - Modern declarative UI
- **CameraX** - Camera access and control
- **Accompanist Permissions** - Permission handling
- **Material 3** - Design components

### Architecture
- Single Activity (`MainActivity`) with Compose
- Flashlight control via `CameraManager`
- Permission management with Accompanist

## Troubleshooting

### Flashlight not turning on
- Ensure flashlight permission is granted
- Check that your device has a flashlight (most modern phones do)
- Some devices may not support torch mode

### Camera preview not showing
- This is a simplified version - for a full camera preview with CameraX integration, consider adding CameraPreview composable

### Permission issues
- Grant both camera and flashlight permissions
- Check Android settings → Apps → Doctor Throat → Permissions

## Future Improvements

- Full live camera preview using CameraX
- Screenshot/save functionality
- Brightness adjustment
- Different examination modes
- Doctor notes/annotations

## License

Simple utility app for personal health examination.

## Disclaimer

This app is a utility tool and is NOT a substitute for professional medical advice. Always consult with a healthcare professional for proper medical diagnosis and treatment.
