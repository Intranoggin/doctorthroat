# Claude Code Guidelines - Doctor Throat Project

Instructions for Claude Code to optimize Android development assistance.

## Project Context

**Project:** Doctor Throat - Android throat examination utility app
**Type:** Native Android App (Kotlin + Jetpack Compose)
**Min SDK:** API 28 (Android 9.0)
**Target SDK:** API 34 (Android 14)

## Development Approach

### Preferred Technologies
- **Language:** Kotlin (not Java)
- **UI Framework:** Jetpack Compose (modern declarative UI)
- **Camera:** CameraX library
- **Build System:** Gradle with Kotlin DSL
- **Architecture:** MVVM with Compose

### Code Style
- Use **Kotlin idioms** - avoid Java patterns
- Prefer **immutable data** - `data class` with `copy()`
- Use **scope functions** - `let`, `apply`, `run`, `with`
- Follow **Google's Android style guide**

### File Organization
```
app/
├── build.gradle.kts          # Module build config
├── src/main/
│   ├── AndroidManifest.xml
│   ├── java/com/doctorthroat/app/
│   │   ├── MainActivity.kt        # Entry point
│   │   ├── ui/                    # Compose UI screens
│   │   ├── viewmodel/             # MVVM ViewModels
│   │   ├── util/                  # Utility functions
│   │   └── data/                  # Data models
│   └── res/
│       ├── values/strings.xml     # Strings (i18n)
│       ├── values/colors.xml      # Color palette
│       └── drawable/              # App icons/assets
└── src/test/                      # Unit tests
```

## Build & Testing

### Build Commands
```bash
# Development build
./gradlew assembleDebug

# Run tests
./gradlew test

# Full build with tests
./gradlew build

# Clean build
./gradlew clean build

# Install on device
./gradlew installDebug
```

### Testing Expectations
- Unit tests in `src/test/`
- Write tests for **business logic**, not UI
- Use JUnit 4 + Mockito/Truth for assertions
- Aim for >80% code coverage for non-UI code

## Code Review Checklist

When Claude makes changes:
- ✅ Does it compile without warnings?
- ✅ Are imports organized (stdlib, androidx, internal)?
- ✅ Does it follow Kotlin conventions?
- ✅ Are edge cases handled (null safety)?
- ✅ Is it testable (dependency injection)?

## Key Dependencies

### Core
- `androidx.activity:activity-compose` - Compose integration
- `androidx.appcompat:appcompat` - Android compatibility
- `androidx.core:core` - Core utilities

### Compose
- `androidx.compose.ui:ui` - UI components
- `androidx.compose.material3:material3` - Material Design 3
- `androidx.compose.ui:ui-tooling-preview` - Preview in IDE

### Camera
- `androidx.camera:camera-core` - Camera interface
- `androidx.camera:camera-camera2` - Camera2 backend
- `androidx.camera:camera-lifecycle` - Lifecycle integration
- `androidx.camera:camera-view` - Preview composable

### Permissions
- `com.google.accompanist:accompanist-permissions` - Runtime permissions

## Common Tasks

### Adding a New Screen
```kotlin
@Composable
fun NewScreen() {
    // Use Material3 components
    // Prefer LazyColumn for lists
    // Use remember {} for state
    // Use MutableState for reactive updates
}
```

### Handling Permissions
```kotlin
val permissionsState = rememberMultiplePermissionsState(
    permissions = listOf(
        Manifest.permission.CAMERA,
        Manifest.permission.FLASHLIGHT
    )
)

LaunchedEffect(Unit) {
    permissionsState.launchMultiplePermissionRequest()
}
```

### Using Camera
- Prefer **CameraX** over Camera2
- Use `Preview` + `ImageCapture` for photos
- Implement proper lifecycle handling
- Handle rotation and multi-window

## Performance Considerations

- **Compose:** Avoid recompositions - use `remember {}` strategically
- **Camera:** Release resources in `onDestroy`
- **Memory:** Monitor heap usage for camera operations
- **Startup:** Keep `onCreate()` lightweight

## Error Handling

- Use **Result<T>** type for recoverable errors
- Throw **IllegalArgumentException** for programming errors
- Show **user-friendly Toast** messages (not crash logs)
- Log errors with appropriate level (E, W, D, I, V)

## Documentation

- Add **KDoc comments** to public APIs
- Document non-obvious logic with `//` comments
- Keep README updated with setup steps
- Document breaking changes in release notes

## Debugging Assistance

When Claude helps debug:
- Check **logcat output** - adb logcat
- Verify **permissions granted** - App permissions settings
- Inspect **device state** - adb shell dumpsys
- Profile **performance** - Android Profiler in Studio

## Dependencies Management

### Adding Dependencies
1. Check version in Maven Central
2. Add to `app/build.gradle.kts`
3. Verify compatibility with minSdk/targetSdk
4. Test build: `./gradlew build`

### Updating Dependencies
```bash
./gradlew dependencyUpdates
```

Keep dependencies current but stable (not alpha/beta unless necessary).

## Git Workflow

- **Branch naming:** `feature/camera-preview`, `fix/permission-bug`
- **Commit message:** Imperative mood: "Add camera preview" not "Added"
- **PR format:** Title + description + test results
- **Code review:** Before merging to main

## Constraints & Limitations

### Device Support
- Min: Android 9.0 (API 28)
- Max: Latest Android (API 34+)
- Test on multiple screen sizes

### Hardware
- Requires camera + flashlight
- Handles devices without flash gracefully
- Supports portrait + landscape orientation

## Getting Help

Common patterns Claude should know:
- **State management:** Use `mutableStateOf()` + `remember {}`
- **Side effects:** Use `LaunchedEffect()` or `DisposableEffect()`
- **Navigation:** CameraX for camera, simple Activity for now
- **Theming:** Material3 `darkColorScheme()` / `lightColorScheme()`

## Performance Targets

- **Launch:** <2 seconds
- **Camera:** 60 FPS preview
- **Memory:** <50MB baseline
- **Battery:** Optimize camera usage

---

**Note:** This guidance evolves with the project. Update CLAUDE.md as practices change.
