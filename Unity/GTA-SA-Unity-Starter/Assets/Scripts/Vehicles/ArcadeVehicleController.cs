using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ArcadeVehicleController : MonoBehaviour
{
    [Header("Wheel colliders")]
    [SerializeField] private WheelCollider frontLeft;
    [SerializeField] private WheelCollider frontRight;
    [SerializeField] private WheelCollider rearLeft;
    [SerializeField] private WheelCollider rearRight;

    [Header("Driving")]
    [SerializeField] private float motorTorque = 1300f;
    [SerializeField] private float brakeTorque = 2500f;
    [SerializeField] private float maxSteerAngle = 28f;
    [SerializeField] private float handbrakeTorque = 4500f;
    [SerializeField] private Transform enterPoint;

    private Rigidbody body;
    private bool playerDriving;

    public bool PlayerDriving
    {
        get => playerDriving;
        set => playerDriving = value;
    }

    public Transform EnterPoint => enterPoint != null ? enterPoint : transform;

    private void Awake()
    {
        body = GetComponent<Rigidbody>();
        body.centerOfMass = new Vector3(0f, -0.45f, 0f);
    }

    private void FixedUpdate()
    {
        float throttle = playerDriving ? Input.GetAxis("Vertical") : 0f;
        float steering = playerDriving ? Input.GetAxis("Horizontal") : 0f;
        bool handbrake = playerDriving && Input.GetKey(KeyCode.Space);

        if (frontLeft != null) frontLeft.steerAngle = steering * maxSteerAngle;
        if (frontRight != null) frontRight.steerAngle = steering * maxSteerAngle;

        ApplyMotor(rearLeft, throttle);
        ApplyMotor(rearRight, throttle);

        float brake = handbrake ? handbrakeTorque : (playerDriving ? 0f : brakeTorque * 0.15f);
        ApplyBrake(frontLeft, brake);
        ApplyBrake(frontRight, brake);
        ApplyBrake(rearLeft, brake);
        ApplyBrake(rearRight, brake);

        UpdateWheelVisual(frontLeft);
        UpdateWheelVisual(frontRight);
        UpdateWheelVisual(rearLeft);
        UpdateWheelVisual(rearRight);
    }

    private void ApplyMotor(WheelCollider wheel, float input)
    {
        if (wheel != null) wheel.motorTorque = input * motorTorque;
    }

    private void ApplyBrake(WheelCollider wheel, float torque)
    {
        if (wheel != null) wheel.brakeTorque = torque;
    }

    private void UpdateWheelVisual(WheelCollider wheel)
    {
        if (wheel == null || wheel.transform.childCount == 0) return;

        Transform visual = wheel.transform.GetChild(0);
        wheel.GetWorldPose(out Vector3 position, out Quaternion rotation);
        visual.SetPositionAndRotation(position, rotation);
    }
}
