using UnityEngine;

public class WorldBootstrap : MonoBehaviour
{
    [SerializeField] private bool createGroundAtRuntime = true;
    [SerializeField] private Vector3 groundScale = new Vector3(20f, 1f, 20f);

    private void Start()
    {
        if (!createGroundAtRuntime) return;

        GameObject ground = GameObject.CreatePrimitive(PrimitiveType.Plane);
        ground.name = "Generated Test Ground";
        ground.transform.localScale = groundScale;
        ground.transform.position = Vector3.zero;

        if (Camera.main == null)
        {
            GameObject cameraObject = new GameObject("Main Camera");
            cameraObject.tag = "MainCamera";
            cameraObject.transform.position = new Vector3(0f, 5f, -8f);
            cameraObject.transform.rotation = Quaternion.Euler(20f, 0f, 0f);
            cameraObject.AddComponent<Camera>();
            cameraObject.AddComponent<AudioListener>();
        }

        if (FindObjectOfType<Light>() == null)
        {
            GameObject lightObject = new GameObject("Directional Light");
            Light light = lightObject.AddComponent<Light>();
            light.type = LightType.Directional;
            lightObject.transform.rotation = Quaternion.Euler(50f, -30f, 0f);
        }
    }
}
