using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistortionControl : MonoBehaviour
{
	[SerializeField] private Material _material;
	[SerializeField, Range(0.01f, 2f)] private float _speed;
	[SerializeField, Range(1f, 20f)] private float _timeToChangeColor = 10f;


	private Color _colorStart = Color.white;
	private Color _colorEnd = Color.red;

	private const string _propertyKey = "_PointOffset";
	private const string _colorKey = "_DistortColor";

	private Vector2 _offset;

	private void OnEnable()
	{
		StartCoroutine(SmoothEnableIllumination());
	}

	private void OnDisable()
	{
		StopAllCoroutines();
		_material.SetColor(_colorKey, _colorStart);
	}

	private void Update()
	{
		if (_material == null)
		{
			return;
		}

		if (Input.GetKey(KeyCode.W))
		{
			_offset.y += Time.deltaTime * _speed;
		}
		if (Input.GetKey(KeyCode.S))
		{
			_offset.y -= Time.deltaTime * _speed;
		}
		if (Input.GetKey(KeyCode.A))
		{
			_offset.x -= Time.deltaTime * _speed;
		}
		if (Input.GetKey(KeyCode.D))
		{
			_offset.x += Time.deltaTime * _speed;
		}

		_material.SetVector(_propertyKey, _offset);
	}

	private IEnumerator SmoothEnableIllumination()
	{
		var time = 0f;
		var deltaTime = 0f;
		while (time < _timeToChangeColor)
		{
			deltaTime = Time.deltaTime;
			_material.SetColor(_colorKey, Color.Lerp(_colorStart, _colorEnd, deltaTime / _timeToChangeColor));
			time += deltaTime;
			yield return null;
		}
	}
}
