# Android Studio Automated Installer
# Run with: powershell -ExecutionPolicy Bypass -File install-android-studio.ps1

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Android Studio Installer" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$androidStudioPath = "$env:ProgramFiles\Android\Android Studio"
$studioExe = "$androidStudioPath\bin\studio.exe"

# Check if already installed
if (Test-Path $studioExe) {
    Write-Host "Android Studio is already installed at:" -ForegroundColor Green
    Write-Host "  $androidStudioPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Launching Android Studio..." -ForegroundColor Cyan
    & $studioExe
    exit 0
}

$installerUrl = "https://redirector.gstatic.com/android/repository/windows/android-studio-2024.1.2-windows.exe"
$installerPath = "$env:TEMP\android-studio-installer.exe"

Write-Host "This will download and install Android Studio (~1.5 GB)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Download URL:" -ForegroundColor Cyan
Write-Host "  $installerUrl" -ForegroundColor White
Write-Host ""
Write-Host "Installation path:" -ForegroundColor Cyan
Write-Host "  $androidStudioPath" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Continue? (Y/n)"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Downloading Android Studio..." -ForegroundColor Cyan
Write-Host "(This may take 10-20 minutes)" -ForegroundColor Yellow
Write-Host ""

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

if (Test-Path $installerPath) {
    Write-Host "Download complete! Running installer..." -ForegroundColor Green
    & $installerPath
} else {
    Write-Host "Download failed!" -ForegroundColor Red
    exit 1
}
