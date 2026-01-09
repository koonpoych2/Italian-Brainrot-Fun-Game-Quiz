@echo off
echo ==========================================
echo   Building Brainrot Quiz - Development
echo ==========================================
echo.

cd /d "%~dp0.."

echo Cleaning previous build...
call flutter clean

echo.
echo Getting dependencies...
call flutter pub get

echo.
echo Building Development APK...
call flutter build apk -t lib/main_dev.dart --debug

echo.
echo ==========================================
echo   Build Complete!
echo ==========================================
echo   APK Location: build\app\outputs\flutter-apk\app-debug.apk
echo ==========================================

pause
