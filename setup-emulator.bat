@echo off
REM Android Emulator Setup Script for Doctor Throat (Windows Batch)
REM This script checks for Android SDK and creates an Android Virtual Device

setlocal enabledelayedexpansion

set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
set "AVD_NAME=Pixel_5_API_34"
set "API_LEVEL=34"
set "DEVICE_ID=Pixel 5"

echo.
echo ================================
echo Android Emulator Setup
echo ================================
echo.

REM Check if Android SDK exists
if not exist "%ANDROID_HOME%" (
    echo ERROR: Android SDK not found at: %ANDROID_HOME%
    echo.
    echo Please install Android Studio first:
    echo 1. Download from: https://developer.android.com/studio
    echo 2. Run the installer
    echo 3. Complete the SDK setup on first launch
    echo.
    pause
    exit /b 1
)

echo [OK] Android SDK found at: %ANDROID_HOME%
echo.

REM Check for avdmanager
set "AVDMANAGER=%ANDROID_HOME%\cmdline-tools\latest\bin\avdmanager.bat"
if not exist "%AVDMANAGER%" (
    echo ERROR: avdmanager not found at: %AVDMANAGER%
    echo Android SDK Build Tools may not be installed
    pause
    exit /b 1
)

echo [OK] avdmanager found
echo.

REM Check for emulator
set "EMULATOR=%ANDROID_HOME%\emulator\emulator.exe"
if not exist "%EMULATOR%" (
    echo ERROR: Emulator not found at: %EMULATOR%
    pause
    exit /b 1
)

echo [OK] Emulator found
echo.

REM Check if system image exists
set "SYSTEM_IMAGE=%ANDROID_HOME%\system-images\android-%API_LEVEL%\google_apis\x86_64"
if not exist "%SYSTEM_IMAGE%" (
    echo WARNING: System image for API %API_LEVEL% not installed
    echo.
    echo Downloading system image (this may take several minutes)...
    echo.

    call "%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat" --sdk_root=%ANDROID_HOME% "system-images;android-%API_LEVEL%;google_apis;x86_64"

    if !ERRORLEVEL! neq 0 (
        echo ERROR: Failed to download system image
        pause
        exit /b 1
    )

    echo [OK] System image downloaded
    echo.
) else (
    echo [OK] System image already installed
    echo.
)

REM Create the AVD
echo Creating AVD: %AVD_NAME%...
echo.

REM Use echo no to respond to the "Do you wish to create a custom hardware profile" prompt
echo no | call "%AVDMANAGER%" create avd -n "%AVD_NAME%" -k "system-images;android-%API_LEVEL%;google_apis;x86_64" -d "%DEVICE_ID%" -f

if %ERRORLEVEL% equ 0 (
    echo.
    echo [OK] AVD created successfully: %AVD_NAME%
) else (
    echo.
    echo WARNING: AVD creation may have encountered an issue
    echo The AVD might already exist or there was a non-fatal error
)

echo.
echo ================================
echo Setup Complete!
echo ================================
echo.
echo To start the emulator, run:
echo   emulator -avd %AVD_NAME%
echo.
echo Or use the helper script:
echo   android-dev-helper.bat emulator %AVD_NAME%
echo.
echo To build and run the app on the emulator:
echo   android-dev-helper.bat run
echo.
echo Happy testing! 🚀
echo.
pause
