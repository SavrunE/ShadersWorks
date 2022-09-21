using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCameraRotate : MonoBehaviour
{

    void Update()
    {
        if (Input.GetKey(KeyCode.A))
            transform.rotation *= Quaternion.Euler(0f, -50f * Time.deltaTime, 0f);
        else if(Input.GetKey(KeyCode.D))
            transform.rotation *= Quaternion.Euler(0f, 50f * Time.deltaTime, 0f);
    }
}
