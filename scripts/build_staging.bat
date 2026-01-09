@echo off
echo ========================================
echo   Building Staging APK
echo ========================================
echo.

cd /d "%~dp0.."

echo Cleaning previous build...
call flutter clean

echo.
echo Getting dependencies...
call flutter pub get

echo.
echo Building Staging APK...
call flutter build apk -t lib/main_staging.dart --release

echo.
echo ========================================
echo   Build Complete!
echo ========================================
echo.
echo Output: build\app\outputs\flutter-apk\app-release.apk
echo.
pause
