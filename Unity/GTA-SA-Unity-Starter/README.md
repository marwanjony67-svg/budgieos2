# BudgieOS GTA-SA Unity Starter

A Unity C# starter for an **original San Andreas-inspired open-world driving game**. This is not the original Rockstar game and does not include GTA: San Andreas maps, characters, missions, audio, or other copyrighted assets.

## Download

**Anyone can download the source project for free:**

- [Download the full BudgieOS repository as ZIP](https://github.com/marwanjony67-svg/budgieos2/archive/refs/heads/main.zip)
- [Browse this Unity starter on GitHub](https://github.com/marwanjony67-svg/budgieos2/tree/main/Unity/GTA-SA-Unity-Starter)
- [Search GitHub for related Unity repositories](https://github.com/search?q=BudgieOS+GTA+Unity&type=repositories)

To download only this project folder, open the project link, then use GitHub's file download options or clone the repository and copy `Unity/GTA-SA-Unity-Starter`.

## Contributions

Contributions are welcome! You can help by fixing bugs, improving C# scripts, adding original models or scenes, improving documentation, or testing builds.

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Fork the repository.
3. Create a branch for your change.
4. Make and test your changes in Unity.
5. Open a Pull Request with a clear description and screenshots or logs when useful.

Please contribute only original work or assets that you have permission to share. Do not upload Rockstar game files or copyrighted GTA assets.

## Recommended editor
- Unity 2022.3 LTS or a compatible newer Unity release
- 3D (Built-In Render Pipeline) project
- Windows PC target

## Included scripts
- `Assets/Scripts/Player/ThirdPersonPlayer.cs` — basic third-person walking and jumping.
- `Assets/Scripts/Camera/FollowCamera.cs` — smooth follow camera.
- `Assets/Scripts/Vehicles/ArcadeVehicleController.cs` — simple arcade car controller using WheelColliders.
- `Assets/Scripts/Vehicles/VehicleEnterExit.cs` — enter/exit a nearby vehicle with the E key.
- `Assets/Scripts/World/WorldBootstrap.cs` — optional runtime ground and lighting setup for a quick test scene.
- `Assets/Editor/BudgieGTAWindowsBuild.cs` — creates a basic test scene and builds a Windows player from the Unity Editor.

## Quick setup
1. In Unity Hub, create a **3D** project.
2. Copy the `Assets` folder from this starter into your Unity project's root folder.
3. In **Edit > Project Settings > Player > Active Input Handling**, choose **Both** or **Input Manager (Old)**. These starter scripts use Unity's built-in legacy Input API.
4. Create a Plane, a Capsule player, and a Camera.
5. Add a `CharacterController` and `ThirdPersonPlayer` to the player Capsule.
6. Add `FollowCamera` to the Camera and assign the player Transform to its Target.
7. Create a car root with a Rigidbody, four WheelColliders, and four visible wheel meshes. Add `ArcadeVehicleController` to the car and assign the wheel references.
8. Add `VehicleEnterExit` to the player and assign the player controller and camera. Set the car's vehicle controller and enter point.
9. Press Play.

## Controls
- Player: WASD / arrow keys to move, Space to jump.
- Vehicle: W/S accelerate and reverse, A/D steer, Space handbrake.
- Enter/exit: E near a vehicle.

## Build for Windows
See [BUILD-WINDOWS.md](BUILD-WINDOWS.md). The Unity Editor is required to compile the project into `BudgieGTA.exe`; the source ZIP is not itself an executable.

## Important notes
- The vehicle script is an arcade prototype, not a realistic driving simulation.
- Tune WheelCollider radius, suspension, friction, mass, and torque for your vehicle model.
- Build your own city, roads, missions, characters, and sound. Use assets you created or have permission to use.
- This is starter source code, not a finished GTA-scale game or a ready-made EXE.
