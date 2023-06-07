using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[RequireComponent(typeof(Camera))]
public class PortalTextureSetup : MonoBehaviour
{
	private Camera _camera;
	[SerializeField] private Material _cameraMat;


    void Start()
    {
	    _camera = GetComponent<Camera>();
	    
		if (_camera.targetTexture != null)
		{
			_camera.targetTexture.Release();
		}
		_camera.targetTexture = new RenderTexture(Screen.width, Screen.height, 24);
		_cameraMat.mainTexture = _camera.targetTexture;

	}
}
