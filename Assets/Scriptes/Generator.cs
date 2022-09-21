using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Generator : MonoBehaviour
{
	[SerializeField] private GameObject _template;
	[SerializeField] private Texture2D _mainTexture;
	[SerializeField] private Texture2D _normal;
	[SerializeField] private Texture2D _metallic;
	private Material _material;
	private GameObject _instant;

	private const string _mainTextureC = "Texture2D_a236e738aab34dcc8a01959e8acf5abd";
	private const string _normalC = "Texture2D_e672aa02e6744f139f8de5b34c2ecac5";
	private const string _metallicC = "Texture2D_fc98ef20aff048d2b311b723b3643dfb";

	private void Start()
	{
		_material = new Material(Shader.Find("BigFade"));
		_material.SetTexture(_mainTextureC, _mainTexture);
		_material.SetTexture(_normalC, _normal);
		_material.SetTexture(_metallicC, _metallic);
		_instant = Instantiate(_template, this.transform.position, Quaternion.identity, this.transform);
		_instant.GetComponent<MeshRenderer>().material = _material;
	}
}
