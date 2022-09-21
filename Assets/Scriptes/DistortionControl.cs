using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistortionControl : MonoBehaviour
{
	[SerializeField] private Material _material;
	[SerializeField, Range(0.01f, 2f)] private float _speed;

	private const string _propertyKey = "_PointOffset";

	private Vector2 _offset;

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
}
