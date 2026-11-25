@echo off
setlocal
title BudgieOS GTA - Windows EXE Builder

if "%~1"=="" (
  echo Usage: BUILD-WINDOWS-EXE.cmd "C:\Path\To\Unity.exe"
  echo Example: BUILD-WINDOWS-EXE.cmd "C:\Program Files\Unity\Hub\Editor\2022.3.XXf1\Editor\Unity.exe"
  pause
  exit /b 1
)

set "UNITY=%~1"
if not exist "%UNITY%" (
  echo Unity.exe not found: "%UNITY%"
  pause
  exit /b 1
)

set "PROJECT=%~dp0"
echo Building BudgieGTA for Windows 64-bit...
"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod BudgieGTA.Editor.BudgieGTAWindowsBuild.BuildWindows -logFile "%PROJECT%Builds\Windows\build.log"
if errorlevel 1 (
  echo Build failed. Check Builds\Windows\build.log
  pause
  exit /b 1
)

echo Build complete: Builds\Windows\BudgieGTA.exe
pause
