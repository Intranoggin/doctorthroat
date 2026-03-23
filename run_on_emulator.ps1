# PowerShell script to run Doctor Throat on Android emulator

$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$emulator = "$sdkPath\emulator\emulator.exe"
$adb = "$sdkPath\platform-tools\adb.exe"
$avdName = "DoctorThroat_AVD"
$apk = "app\build\outputs\apk\debug\app-debug.apk"

Write-Host "Starting Android Emulator: $avdName" -ForegroundColor Green
Write-Host ""

# Start emulator
Write-Host "Launching emulator..." -ForegroundColor Cyan
Start-Process -FilePath $emulator -ArgumentList "-avd", $avdName, "-no-snapshot-load", "-no-audio", "-delay-adb"

# Wait for emulator to boot
Write-Host "Waiting 60 seconds for emulator to boot..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Check devices
Write-Host ""
Write-Host "Connected devices:" -ForegroundColor Cyan
& $adb devices

# Wait for device
Write-Host ""
Write-Host "Waiting for device to be ready..." -ForegroundColor Yellow
& $adb wait-for-device

# Install app
Write-Host ""
Write-Host "Building and installing app..." -ForegroundColor Cyan
Write-Host ""
./gradlew.bat installDebug

# Launch app
Write-Host ""
Write-Host "Launching Doctor Throat app..." -ForegroundColor Green
& $adb shell am start -n com.doctorthroat.app/.MainActivity

Write-Host ""
Write-Host "[OK] Done! Check your emulator screen." -ForegroundColor Green
