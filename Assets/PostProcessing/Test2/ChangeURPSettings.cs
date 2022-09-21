using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

[RequireComponent(typeof(Camera))]
public class ChangeURPSettings : MonoBehaviour
{
	private Camera _camera;
	[SerializeField] RenderPipelineAsset _URP;
	[SerializeField] private Renderer[] _renderers;

	private void Awake()
	{
		//UnityEngine.Rendering.Universal.UniversalAdditionalCameraData additionalCameraData =
		//	cam.transform.GetComponent<UnityEngine.Rendering.Universal.UniversalAdditionalCameraData>();

		//additionalCameraData.SetRenderer(newIndex);
	
		_camera = this.gameObject.GetComponent<Camera>();
		//_camera.renderingPath.
	}
}
