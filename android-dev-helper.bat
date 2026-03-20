@echo off
REM Android Development Helper Script for Doctor Throat (Windows)

setlocal enabledelayedexpansion

REM Configuration
set GRADLE_CMD=gradlew.bat
set APK_PATH=app\build\outputs\apk\debug\app-debug.apk

REM Check if help or no args
if "%1"=="" goto :help
if "%1"=="help" goto :help
if "%1"=="--help" goto :help
if "%1"=="-h" goto :help

REM Main command dispatcher
if "%1"=="build" goto :build
if "%1"=="test" goto :test
if "%1"=="devices" goto :devices
if "%1"=="install" goto :install
if "%1"=="run" goto :run
if "%1"=="logs" goto :logs
if "%1"=="clean" goto :clean
if "%1"=="emulator" goto :emulator
goto :invalid_command

:build
echo Building Doctor Throat APK...
call %GRADLE_CMD% clean build
if %ERRORLEVEL% EQU 0 (
    echo Build successful!
    echo APK location: %APK_PATH%
) else (
    echo Build failed!
    exit /b 1
)
goto :eof

:test
echo Running tests...
call %GRADLE_CMD% test
if %ERRORLEVEL% EQU 0 (
    echo Tests completed!
) else (
    echo Tests failed!
    exit /b 1
)
goto :eof

:devices
echo Connected devices:
adb devices -l
goto :eof

:install
if not exist "%APK_PATH%" (
    echo APK not found. Building first...
    call :build
)
echo Installing APK...
adb install -r "%APK_PATH%"
if %ERRORLEVEL% EQU 0 (
    echo Installation complete!
) else (
    echo Installation failed!
    exit /b 1
)
goto :eof

:run
call :install
if %ERRORLEVEL% EQU 0 (
    echo Launching app...
    adb shell am start -n com.doctorthroat.app/.MainActivity
    echo App started!
) else (
    echo Failed to install app
    exit /b 1
)
goto :eof

:logs
echo Device logs (Doctor Throat):
adb logcat com.doctorthroat.app:V *:S
goto :eof

:clean
echo Cleaning build artifacts...
call %GRADLE_CMD% clean
if %ERRORLEVEL% EQU 0 (
    echo Clean complete!
) else (
    echo Clean failed!
    exit /b 1
)
goto :eof

:emulator
if "%2"=="" (
    echo Usage: %0 emulator [avd_name]
    echo Example: %0 emulator Pixel_5_API_31
    exit /b 1
)
echo Starting emulator: %2
start "" emulator -avd %2 -no-snapshot-load
timeout /t 5
call :devices
goto :eof

:help
echo Doctor Throat - Android Development Helper
echo.
echo Usage: %0 [command]
echo.
echo Commands:
echo   build      - Build the APK
echo   test       - Run unit tests
echo   devices    - List connected devices/emulators
echo   install    - Build and install APK on device
echo   run        - Build, install, and launch app
echo   logs       - Show device logs
echo   clean      - Clean build artifacts
echo   emulator   - Start emulator by AVD name
echo   help       - Show this help message
echo.
echo Examples:
echo   %0 build
echo   %0 run
echo   %0 emulator Pixel_5_API_31
echo   %0 logs
echo.
goto :eof

:invalid_command
echo Unknown command: %1
call :help
exit /b 1
