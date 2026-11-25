# BudgieGTA6 — BudgieOS Windows PC Starter

An original open-world action/driving game prototype built with **Unreal Engine 5 and C++**. This is a new fan-inspired project, not Rockstar's GTA 6 and does not include Rockstar source code, maps, characters, missions, audio, or other proprietary assets.

## Requirements
- Unreal Engine 5.x installed through Epic Games Launcher
- Visual Studio 2022 with Desktop development with C++ and Game development with C++
- Windows 10/11 64-bit
- A Windows-compatible Unreal Engine toolchain

## Project contents
- `BudgieGTA6.uproject` — Unreal project descriptor.
- `Source/BudgieGTA6/` — C++ game module, GameMode, and third-person player character.
- `Config/` — default input and game configuration.
- `BUILD-WINDOWS-EXE.bat` — packaging helper for Windows.

## Open the project
1. Install Unreal Engine 5.x and Visual Studio 2022 C++ workloads.
2. Download this folder or clone the repository.
3. Right-click `BudgieGTA6.uproject` and choose **Generate Visual Studio project files** (if offered).
4. Open `BudgieGTA6.sln` or open the `.uproject` in Unreal Editor.
5. Let Unreal compile the C++ module.

## Create the first map
The repository contains C++ starter code, not a finished city map. In Unreal Editor:
1. Create a new Level and save it as `/Game/Maps/BudgieCity`.
2. Add a large floor, a few cubes as buildings, a Player Start, and a Directional Light.
3. Open **Edit > Project Settings > Maps & Modes**.
4. Set both Editor Startup Map and Game Default Map to `/Game/Maps/BudgieCity`.
5. Set Default GameMode to `BudgieGTA6GameMode`.
6. Save the level.

## Controls
- W/A/S/D — move
- Mouse — look around
- Space — jump

The starter uses Unreal's legacy input mappings so it can be tested without creating Enhanced Input assets.

## Build a Windows EXE
After creating and saving `/Game/Maps/BudgieCity`:
1. Close Play-in-Editor.
2. Run `BUILD-WINDOWS-EXE.bat`.
3. When prompted, enter the Unreal Engine installation folder, for example `C:\Program Files\Epic Games\UE_5.4`.
4. The script runs Unreal Automation Tool to build and package a Windows 64-bit Development game.

Expected output folder:
`Build/Windows/BudgieGTA6/`

Run the packaged `BudgieGTA6.exe` inside that folder. Keep the accompanying `BudgieGTA6` data folder and other packaged files together.

## Important
- This is a starter framework, not a completed GTA-scale game.
- You must install Unreal Engine locally to compile and package the executable. GitHub cannot compile Unreal projects by itself.
- Use original or properly licensed art, audio, and other content.
