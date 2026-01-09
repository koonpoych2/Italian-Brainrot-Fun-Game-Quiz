@echo off
echo ========================================
echo   Brainrot Quiz - Production Build
echo ========================================
echo.

REM Navigate to project root
cd /d "%~dp0\.."

echo [1/4] Cleaning previous build...
call flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter clean failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Getting dependencies...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter pub get failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Running analyzer...
call flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Analyzer found issues. Continue anyway? (Y/N)
    set /p continue=
    if /i not "%continue%"=="Y" (
        echo Build cancelled.
        pause
        exit /b 1
    )
)

echo.
echo [4/4] Building production App Bundle...
call flutter build appbundle -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build Successful!
echo ========================================
echo.
echo Output locations:
echo   App Bundle: build\app\outputs\bundle\release\app-release.aab
echo   Debug Info: build\debug-info\
echo.
echo IMPORTANT: Keep the debug-info folder for crash reporting!
echo.
pause
