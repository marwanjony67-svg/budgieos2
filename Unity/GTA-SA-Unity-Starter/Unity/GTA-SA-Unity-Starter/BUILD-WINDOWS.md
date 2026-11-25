# Build BudgieGTA.exe for Windows

## Important
The repository starter is source code, not a precompiled game. You need Unity Editor installed to compile it. The generated game is an original small prototype scene, not the full commercial GTA: San Andreas game.

## Prepare the Unity project
1. Install Unity Hub and a Unity Editor version compatible with the project scripts (Unity 2022.3 LTS recommended).
2. In Unity Hub, create a new **3D** project named `BudgieGTA`.
3. Copy the complete `Assets` folder from this starter into the new project's root folder, merging folders if asked.
4. Copy `BUILD-WINDOWS-EXE.cmd` into the new project's root folder (next to `Assets`).
5. Open the project in Unity once and wait for scripts to compile.

## Build
Find the installed Unity Editor executable. Example path (replace the version with yours):

```bat
"C:\Program Files\Unity\Hub\Editor\2022.3.XXf1\Editor\Unity.exe"
```

Run the batch file from Command Prompt:

```bat
BUILD-WINDOWS-EXE.cmd "C:\Program Files\Unity\Hub\Editor\2022.3.XXf1\Editor\Unity.exe"
```

The build script creates a starter scene if one does not exist and builds a 64-bit Windows player.

## Output
`Builds/Windows/BudgieGTA.exe`

Keep the accompanying `BudgieGTA_Data` folder beside the EXE. Do not distribute the EXE by itself.

## Troubleshooting
- If the script compile fails, open Unity and inspect the Console window.
- Ensure Windows Build Support (IL2CPP or Mono) is installed in Unity Hub.
- The build command writes a log to `Builds/Windows/build.log`.
- This prototype uses Unity's legacy Input Manager. Set **Active Input Handling** to **Both** or **Input Manager (Old)** in Project Settings > Player.
