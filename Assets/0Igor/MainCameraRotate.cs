using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;

public class MainCameraRotate : MonoBehaviour
{
	private float _mSensitivity = 2.0f;

	private Vector2 _lastRotation;

	private void Start()
	{
		_lastRotation = new Vector2(transform.rotation.x, transform.rotation.y);
	}

	private void Update()
	{
		if (Input.GetMouseButton(1))
		{
			float x;
			float y;

			x = Input.GetAxisRaw("M_Y") * _mSensitivity;
			y = Input.GetAxisRaw("M_X") * _mSensitivity;

			_lastRotation = _lastRotation + new Vector2(x, -y);
			_lastRotation.x = Mathf.Clamp(_lastRotation.x, 80.0f, 100.0f);
			_lastRotation.y = Mathf.Clamp(_lastRotation.y, -10.0f, 10.0f);

			UpdateRotation();
		}
	}

	private void UpdateRotation()
	{
		Quaternion qX = Quaternion.AngleAxis(_lastRotation.x, Vector3.right);
		Quaternion qY = Quaternion.Euler(0f, _lastRotation.y, 0f);

		transform.rotation = qX * qY;
	}
}