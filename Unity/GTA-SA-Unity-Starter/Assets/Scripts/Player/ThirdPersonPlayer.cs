using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class ThirdPersonPlayer : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private float turnSpeed = 12f;
    [SerializeField] private float jumpHeight = 1.2f;
    [SerializeField] private float gravity = -20f;
    [SerializeField] private Transform cameraTransform;

    private CharacterController controller;
    private Vector3 verticalVelocity;
    private bool controlsEnabled = true;

    public bool ControlsEnabled
    {
        get => controlsEnabled;
        set => controlsEnabled = value;
    }

    private void Awake()
    {
        controller = GetComponent<CharacterController>();
        if (cameraTransform == null && Camera.main != null)
            cameraTransform = Camera.main.transform;
    }

    private void Update()
    {
        if (!controlsEnabled)
        {
            ApplyGravity();
            return;
        }

        Vector2 input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        input = Vector2.ClampMagnitude(input, 1f);

        Vector3 forward = cameraTransform != null ? cameraTransform.forward : Vector3.forward;
        Vector3 right = cameraTransform != null ? cameraTransform.right : Vector3.right;
        forward.y = 0f;
        right.y = 0f;
        forward.Normalize();
        right.Normalize();

        Vector3 move = forward * input.y + right * input.x;
        if (move.sqrMagnitude > 0.001f)
        {
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                Quaternion.LookRotation(move),
                turnSpeed * Time.deltaTime);
        }

        controller.Move(move * moveSpeed * Time.deltaTime);

        if (controller.isGrounded && verticalVelocity.y < 0f)
            verticalVelocity.y = -2f;

        if (controller.isGrounded && Input.GetButtonDown("Jump"))
            verticalVelocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);

        ApplyGravity();
    }

    private void ApplyGravity()
    {
        if (controller.isGrounded && verticalVelocity.y < 0f)
            verticalVelocity.y = -2f;

        verticalVelocity.y += gravity * Time.deltaTime;
        controller.Move(verticalVelocity * Time.deltaTime);
    }
}
