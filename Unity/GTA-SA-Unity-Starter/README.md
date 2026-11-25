# BudgieOS GTA-SA Unity Starter

A Unity C# starter for an **original San Andreas-inspired open-world driving game**. This is not the original Rockstar game and does not include GTA: San Andreas maps, characters, missions, audio, or other copyrighted assets.

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

## Important notes
- The vehicle script is an arcade prototype, not a realistic driving simulation.
- Tune WheelCollider radius, suspension, friction, mass, and torque for your vehicle model.
- Build your own city, roads, missions, characters, and sound. Use assets you created or have permission to use.
- This is starter source code, not a finished GTA-scale game or a ready-made EXE.

## Build for Windows
In Unity, open **File > Build Profiles** (or **Build Settings** in older versions), select Windows, add your gameplay scene, and choose **Build**.
