# Android Emulator Setup Script for Doctor Throat
# Run with: powershell -ExecutionPolicy Bypass -File setup-emulator.ps1

param(
    [string]$AndroidHome = "$env:LOCALAPPDATA\Android\Sdk",
    [string]$AvdName = "Pixel_5_API_34",
    [string]$ApiLevel = "34",
    [string]$DeviceId = "Pixel 5"
)

# Colors for output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }
function Write-Warning { Write-Host $args -ForegroundColor Yellow }
function Write-Info { Write-Host $args -ForegroundColor Cyan }

Write-Info "================================"
Write-Info "Android Emulator Setup"
Write-Info "================================"
Write-Info ""

# Check if Android SDK exists
if (-not (Test-Path $AndroidHome)) {
    Write-Error "❌ Android SDK not found at: $AndroidHome"
    Write-Warning ""
    Write-Warning "Please install Android Studio first:"
    Write-Warning "1. Download from: https://developer.android.com/studio"
    Write-Warning "2. Run the installer"
    Write-Warning "3. Complete the SDK setup on first launch"
    Write-Warning ""
    exit 1
}

Write-Success "✓ Android SDK found at: $AndroidHome"

# Set ANDROID_HOME environment variable
$env:ANDROID_HOME = $AndroidHome
$env:ANDROID_SDK_ROOT = $AndroidHome

Write-Info ""
Write-Info "Checking for required tools..."

# Check for avdmanager
$avdmanager = "$AndroidHome\cmdline-tools\latest\bin\avdmanager.bat"
if (-not (Test-Path $avdmanager)) {
    Write-Error "❌ avdmanager not found"
    Write-Warning "Android SDK Build Tools may not be installed"
    exit 1
}

Write-Success "✓ avdmanager found"

# Check for emulator
$emulator = "$AndroidHome\emulator\emulator.exe"
if (-not (Test-Path $emulator)) {
    Write-Error "❌ Emulator not found at: $emulator"
    exit 1
}

Write-Success "✓ Emulator found"

Write-Info ""
Write-Info "Checking for API $ApiLevel system image..."

# Check if system image exists
$systemImage = "$AndroidHome\system-images\android-$ApiLevel\google_apis\x86_64"
if (-not (Test-Path $systemImage)) {
    Write-Warning "⚠ System image for API $ApiLevel not installed"
    Write-Info "Downloading system image (this may take a few minutes)..."

    & "$AndroidHome\cmdline-tools\latest\bin\sdkmanager.bat" --sdk_root=$AndroidHome "system-images;android-$ApiLevel;google_apis;x86_64"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Failed to download system image"
        exit 1
    }

    Write-Success "✓ System image downloaded"
} else {
    Write-Success "✓ System image already installed"
}

Write-Info ""
Write-Info "Creating AVD: $AvdName..."

# Create the AVD
Write-Info "Running: avdmanager create avd -n `"$AvdName`" -k `"system-images;android-$ApiLevel;google_apis;x86_64`" -d `"$DeviceId`" -f"

echo "no" | & "$avdmanager" create avd -n "$AvdName" -k "system-images;android-$ApiLevel;google_apis;x86_64" -d "$DeviceId" -f

if ($LASTEXITCODE -eq 0) {
    Write-Success "✓ AVD created successfully: $AvdName"
} else {
    Write-Warning "⚠ AVD creation returned exit code: $LASTEXITCODE"
    Write-Info "AVD may already exist or there was a non-fatal issue"
}

Write-Info ""
Write-Info "================================"
Write-Info "Setup Complete!"
Write-Info "================================"
Write-Info ""
Write-Info "To start the emulator, run:"
Write-Info "  emulator -avd $AvdName"
Write-Info ""
Write-Info "Or use the helper script:"
Write-Info "  .\android-dev-helper.bat emulator $AvdName"
Write-Info ""
Write-Info "To build and run the app on the emulator:"
Write-Info "  .\android-dev-helper.bat run"
Write-Info ""
Write-Success "Happy testing! 🚀"
