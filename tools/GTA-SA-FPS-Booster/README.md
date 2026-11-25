# BudgieOS GTA SA FPS Booster v1.0

A small PowerShell/CMD launcher for **Classic Grand Theft Auto: San Andreas on Windows PC**.

## What it does

- Asks for the path to the original `gta_sa.exe`.
- Starts the game using its own installation folder as the working directory.
- Sets the GTA process priority to **AboveNormal** while the game is running.
- Waits for the game to close, then exits.

## What it does not do

- It does not modify GTA files, save files, or the Windows registry.
- It does not disable Windows security or stop background services.
- It does not overclock hardware or change CPU/GPU settings.
- It cannot guarantee higher FPS. Process priority may make little or no difference on some PCs.

## Run it

1. Download this folder from the repository.
2. Keep both files in the same folder.
3. Double-click `START-BUDGIEOS-GTA-SA-FPS.cmd`.
4. Enter the full path to your classic game's `gta_sa.exe`, for example:
   `C:\\Games\\GTA San Andreas\\gta_sa.exe`

PowerShell is included with supported Windows versions. Administrator rights are not normally needed.

## Notes about classic GTA SA FPS

Classic GTA SA has game logic tied to frame rate. An unlimited FPS setting can cause gameplay, physics, or animation issues. Start with the game's built-in Frame Limiter enabled and test changes carefully.

This launcher is a lightweight shell helper, not an FPS patch. For actual frame pacing fixes, review the upstream projects and confirm that your game executable matches their supported version before installing anything:

- [gtasa-vsync-fix](https://github.com/Lintech-1/gtasa-vsync-fix) — specifically documents GTA San Andreas 1.0 US.
- [sa-high-fps-fixes](https://github.com/sonochiwa/sa-high-fps-fixes) — fixes several frame-rate-dependent behaviours and documents its supported executable versions.

These are third-party projects, not included or maintained by BudgieOS. Back up your game folder before installing mods, and use single-player only.

## Files

- `START-BUDGIEOS-GTA-SA-FPS.cmd` — double-click launcher.
- `Start-GTA-SA-FPS.ps1` — PowerShell launcher logic.
