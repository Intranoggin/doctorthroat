# PowerShell script to uninstall, rebuild, and reinstall Doctor Throat on phone

$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$adb = "$sdkPath\platform-tools\adb.exe"
$packageName = "com.doctorthroat.app"

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Doctor Throat - Phone Reinstall" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Check devices
Write-Host ""
Write-Host "Connected devices:" -ForegroundColor Yellow
& $adb devices

# Uninstall
Write-Host ""
Write-Host "Uninstalling app..." -ForegroundColor Yellow
& $adb uninstall $packageName
Start-Sleep -Seconds 2

# Clean build
Write-Host ""
Write-Host "Building app..." -ForegroundColor Yellow
& ./gradlew.bat clean assembleDebug

# Install
Write-Host ""
Write-Host "Installing app..." -ForegroundColor Yellow
& ./gradlew.bat installDebug

# Launch
Write-Host ""
Write-Host "Launching app..." -ForegroundColor Yellow
& $adb shell am start -n "$packageName/.MainActivity"

Write-Host ""
Write-Host "Done! Check your phone." -ForegroundColor Green
