using UnityEngine;

public class VehicleEnterExit : MonoBehaviour
{
    [SerializeField] private float enterDistance = 3f;
    [SerializeField] private ThirdPersonPlayer playerController;
    [SerializeField] private FollowCamera followCamera;
    [SerializeField] private KeyCode interactionKey = KeyCode.E;

    private ArcadeVehicleController currentVehicle;
    private Transform originalParent;

    private void Update()
    {
        if (!Input.GetKeyDown(interactionKey)) return;

        if (currentVehicle == null)
            TryEnterVehicle();
        else
            ExitVehicle();
    }

    private void TryEnterVehicle()
    {
        ArcadeVehicleController[] vehicles = FindObjectsOfType<ArcadeVehicleController>();
        ArcadeVehicleController nearest = null;
        float bestDistance = enterDistance;

        foreach (ArcadeVehicleController vehicle in vehicles)
        {
            float distance = Vector3.Distance(transform.position, vehicle.EnterPoint.position);
            if (distance < bestDistance)
            {
                bestDistance = distance;
                nearest = vehicle;
            }
        }

        if (nearest == null) return;

        currentVehicle = nearest;
        originalParent = transform.parent;
        if (playerController != null) playerController.ControlsEnabled = false;

        CharacterController characterController = GetComponent<CharacterController>();
        if (characterController != null) characterController.enabled = false;

        transform.SetParent(currentVehicle.transform);
        transform.position = currentVehicle.EnterPoint.position + Vector3.up * 0.5f;
        currentVehicle.PlayerDriving = true;
        if (followCamera != null) followCamera.Target = currentVehicle.transform;
    }

    private void ExitVehicle()
    {
        Transform exitPosition = currentVehicle.EnterPoint;
        currentVehicle.PlayerDriving = false;
        transform.SetParent(originalParent);
        transform.position = exitPosition.position + exitPosition.right * 2f + Vector3.up * 0.2f;

        CharacterController characterController = GetComponent<CharacterController>();
        if (characterController != null) characterController.enabled = true;
        if (playerController != null) playerController.ControlsEnabled = true;
        if (followCamera != null) followCamera.Target = transform;

        currentVehicle = null;
    }
}
