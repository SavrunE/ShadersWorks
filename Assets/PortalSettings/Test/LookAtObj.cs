using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtObj : MonoBehaviour
{
    [SerializeField] private Transform _lookTo;

    private void Update()
    {
        transform.LookAt(_lookTo);
    }
}
