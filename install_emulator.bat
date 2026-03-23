@echo off
setlocal enabledelayedexpansion

set SDK_PATH=%LOCALAPPDATA%\Android\Sdk
set EMULATOR=%SDK_PATH%\emulator\emulator.exe
set ADB=%SDK_PATH%\platform-tools\adb.exe
set AVD_NAME=DoctorThroat_AVD

echo Starting emulator: %AVD_NAME%
start "" "%EMULATOR%" -avd %AVD_NAME% -no-snapshot-load -no-audio -delay-adb

echo Waiting 60 seconds for emulator to boot...
timeout /t 60 /nobreak

echo Checking connected devices...
"%ADB%" devices

echo Waiting for device to be ready...
"%ADB%" wait-for-device

echo Building and installing app...
call gradlew.bat installDebug

echo Installation complete!
"%ADB%" shell am start -n com.doctorthroat.app/.MainActivity

pause
