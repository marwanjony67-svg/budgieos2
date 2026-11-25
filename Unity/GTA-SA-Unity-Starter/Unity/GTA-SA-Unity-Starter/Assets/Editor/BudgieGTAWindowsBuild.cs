#if UNITY_EDITOR
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace BudgieGTA.Editor
{
    public static class BudgieGTAWindowsBuild
    {
        private const string ScenePath = "Assets/Scenes/Main.unity";

        [MenuItem("BudgieGTA/Build Windows EXE")]
        public static void BuildWindows()
        {
            EnsureFolders();
            EnsureStarterScene();

            string output = Path.GetFullPath("Builds/Windows/BudgieGTA.exe");
            Directory.CreateDirectory(Path.GetDirectoryName(output));

            EditorBuildSettings.scenes = new[]
            {
                new EditorBuildSettingsScene(ScenePath, true)
            };

            PlayerSettings.productName = "BudgieGTA";
            PlayerSettings.companyName = "BudgieOS";
            PlayerSettings.defaultScreenWidth = 1280;
            PlayerSettings.defaultScreenHeight = 720;

            BuildPlayerOptions options = new BuildPlayerOptions
            {
                scenes = new[] { ScenePath },
                locationPathName = output,
                target = BuildTarget.StandaloneWindows64,
                options = BuildOptions.None
            };

            BuildReport report = BuildPipeline.BuildPlayer(options);
            if (report.summary.result != UnityEditor.Build.Reporting.BuildResult.Succeeded)
                throw new System.Exception("Windows build failed: " + report.summary.result);

            Debug.Log("BudgieGTA Windows build created: " + output);
        }

        private static void EnsureFolders()
        {
            Directory.CreateDirectory("Assets/Scenes");
            Directory.CreateDirectory("Builds/Windows");
            AssetDatabase.Refresh();
        }

        private static void EnsureStarterScene()
        {
            if (File.Exists(ScenePath)) return;

            Scene scene = EditorSceneManager.NewScene(
                NewSceneSetup.EmptyScene, NewSceneMode.Single);

            GameObject ground = GameObject.CreatePrimitive(PrimitiveType.Plane);
            ground.name = "Test City Ground";
            ground.transform.localScale = new Vector3(12f, 1f, 12f);

            GameObject player = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            player.name = "Player";
            player.transform.position = new Vector3(0f, 1f, -4f);
            CharacterController character = player.AddComponent<CharacterController>();
            character.height = 2f;
            character.radius = 0.45f;
            ThirdPersonPlayer movement = player.AddComponent<ThirdPersonPlayer>();

            GameObject cameraObject = new GameObject("Main Camera");
            cameraObject.tag = "MainCamera";
            Camera camera = cameraObject.AddComponent<Camera>();
            camera.fieldOfView = 60f;
            cameraObject.AddComponent<AudioListener>();
            FollowCamera follow = cameraObject.AddComponent<FollowCamera>();
            follow.Target = player.transform;
            movement.SendMessage("SetCameraTransformIfAvailable", cameraObject.transform,
                SendMessageOptions.DontRequireReceiver);

            GameObject lightObject = new GameObject("Directional Light");
            Light light = lightObject.AddComponent<Light>();
            light.type = LightType.Directional;
            lightObject.transform.rotation = Quaternion.Euler(50f, -30f, 0f);

            GameObject car = GameObject.CreatePrimitive(PrimitiveType.Cube);
            car.name = "Starter Car";
            car.transform.position = new Vector3(3f, 0.8f, 2f);
            car.transform.localScale = new Vector3(1.8f, 0.7f, 3.5f);
            Rigidbody body = car.AddComponent<Rigidbody>();
            body.mass = 1200f;
            ArcadeVehicleController vehicle = car.AddComponent<ArcadeVehicleController>();

            WheelCollider fl = CreateWheel(car.transform, "FrontLeftWheel", -0.85f, 0.25f, 1.1f);
            WheelCollider fr = CreateWheel(car.transform, "FrontRightWheel", 0.85f, 0.25f, 1.1f);
            WheelCollider rl = CreateWheel(car.transform, "RearLeftWheel", -0.85f, 0.25f, -1.1f);
            WheelCollider rr = CreateWheel(car.transform, "RearRightWheel", 0.85f, 0.25f, -1.1f);

            SerializedObject vehicleData = new SerializedObject(vehicle);
            vehicleData.FindProperty("frontLeft").objectReferenceValue = fl;
            vehicleData.FindProperty("frontRight").objectReferenceValue = fr;
            vehicleData.FindProperty("rearLeft").objectReferenceValue = rl;
            vehicleData.FindProperty("rearRight").objectReferenceValue = rr;
            vehicleData.ApplyModifiedPropertiesWithoutUndo();

            VehicleEnterExit enterExit = player.AddComponent<VehicleEnterExit>();
            SerializedObject enterData = new SerializedObject(enterExit);
            enterData.FindProperty("playerController").objectReferenceValue = movement;
            enterData.FindProperty("followCamera").objectReferenceValue = follow;
            enterData.ApplyModifiedPropertiesWithoutUndo();

            EditorSceneManager.SaveScene(scene, ScenePath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        private static WheelCollider CreateWheel(Transform parent, string name,
            float x, float y, float z)
        {
            GameObject wheel = new GameObject(name);
            wheel.transform.SetParent(parent, false);
            wheel.transform.localPosition = new Vector3(x, y, z);
            WheelCollider collider = wheel.AddComponent<WheelCollider>();
            collider.radius = 0.35f;
            collider.suspensionDistance = 0.2f;
            return collider;
        }
    }
}
#endif
