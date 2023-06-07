// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
//
// public class RenderPlaneChanger : MonoBehaviour
// {
// 	private void OnEnable()
// 	{
// 		StartCoroutine(SmoothEnableIllumination());
// 	}
//
// 	private void OnDisable()
// 	{
// 		StopAllCoroutines();
// 	}
//
// 	private IEnumerator SmoothEnableIllumination()
// 	{
// 		var time = 0f;
// 		while (true)
// 		{
// 			_material.SetFloat(_propertyKey, Lerp(_colorStart, _colorEnd, time / _timeToOpen));
// 			time += Time.deltaTime;
// 			yield return null;
// 		}
// 		
// 		yield return null;
// 		_material.(_propertyKey, );
// 	}
// }