using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCamera : MonoBehaviour
{
	[SerializeField] private Transform _playerCamera;
	[SerializeField] private Transform _portal;

	void Update()
	{
		//Vector3 playerOffsetFromPortal = _playerCamera.position - _otherPortal.position;
		//transform.position = _portal.position + playerOffsetFromPortal;

		float angularDifference = Quaternion.Angle(_playerCamera.rotation, _portal.rotation);

		Quaternion portalRotationalDifference = Quaternion.AngleAxis(-angularDifference, Vector3.up);
		Vector3 newCamerasDirection = portalRotationalDifference * _playerCamera.right;
		transform.rotation = Quaternion.LookRotation(newCamerasDirection, Vector3.up);
	}
}