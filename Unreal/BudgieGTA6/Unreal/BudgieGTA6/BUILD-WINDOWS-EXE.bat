@echo off
setlocal EnableExtensions
title BudgieOS BudgieGTA6 Windows Builder

set "PROJECT_DIR=%~dp0"
set "UPROJECT=%PROJECT_DIR%BudgieGTA6.uproject"

if not exist "%UPROJECT%" (
  echo ERROR: BudgieGTA6.uproject not found.
  pause
  exit /b 1
)

set "UE_ROOT=%~1"
if "%UE_ROOT%"=="" set /p UE_ROOT=Enter Unreal Engine folder, e.g. C:\Program Files\Epic Games\UE_5.4: 

if not exist "%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" (
  echo ERROR: Unreal Engine Build.bat not found under "%UE_ROOT%".
  pause
  exit /b 1
)

set "UAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"
set "OUTPUT=%PROJECT_DIR%Build\Windows"

if not exist "%UAT%" (
  echo ERROR: RunUAT.bat not found.
  pause
  exit /b 1
)

echo Building and packaging BudgieGTA6 for Windows 64-bit...
call "%UAT%" BuildCookRun -project="%UPROJECT%" -noP4 -platform=Win64 -clientconfig=Development -build -cook -stage -pak -archive -archivedirectory="%OUTPUT%" -utf8output

if errorlevel 1 (
  echo.
  echo BUILD FAILED. Check the Unreal Automation Tool output above.
  pause
  exit /b 1
)

echo.
echo BUILD COMPLETE. Look in:
echo %OUTPUT%
echo Keep the packaged data folders beside BudgieGTA6.exe.
pause
