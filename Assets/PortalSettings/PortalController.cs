using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalController : MonoBehaviour
{
    private bool _isOpen = false;
    private  float scale;

    private void Start()
    {
        transform.localScale = Vector3.zero;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (_isOpen == false)
            {
                _isOpen = true;
               
                // while (transform.localScale.x < 1f)
                // {
                //     float timePar = Time.deltaTime;
                //     transform.localScale = new Vector3(scale + timePar,scale + timePar,scale + timePar);
                //    await System.Threading.Tasks.Task.Delay(timePar);
                // }
                StartCoroutine(Open());
            }
            else
            {
                _isOpen = false;
                StartCoroutine(Close());
            }
        }
    }

    private IEnumerator Open()
    {
        float q = 0f;
        while (q < 1f)
        {
            q += .1f;
            transform.localScale = new Vector3(q, q, q);
            yield return new WaitForSeconds(.05f);
        }
    }

    private IEnumerator Close()
    {
        float q = 1f;
        while (q > 0f)
        {
            q -= .1f;
            transform.localScale = new Vector3(q, q, q);
            yield return new WaitForSeconds(.05f);
        }
    }
}