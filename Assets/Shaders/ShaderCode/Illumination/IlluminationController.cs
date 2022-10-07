using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IlluminationController : MonoBehaviour
{
    [SerializeField] private Material _material;

    private const string _propertyKey = "_isBlink";

    private Vector2 _offset;

    private void Update()
    {

        if (Input.GetKey(KeyCode.Space))
        {
            _material.SetFloat(_propertyKey, 1f);
        }
        else
        {
            _material.SetFloat(_propertyKey, 0f);
        }
    }
}
