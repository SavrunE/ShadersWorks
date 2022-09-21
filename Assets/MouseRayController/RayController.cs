using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class RayController : MonoBehaviour
{
    private Camera _camera;
    private Outline _previousOutline;
    [SerializeField] private Texture2D _cursorClick;
    [SerializeField] private Texture2D _cursorDefault;

    private void Awake()
    {
        _camera = GetComponent<Camera>();
    }

    private void Update()
    {
        Ray ray = _camera.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 100))
        {
            var outline = hit.collider.GetComponent<Outline>();
            if (outline != null)
            {
                if (outline != this && outline != _previousOutline)
                {
                    Debug.Log("OnHoverEnter");
                    Cursor.SetCursor(_cursorClick, Vector2.zero, CursorMode.ForceSoftware);
                    outline.OutlineWidth = 2;
                    _previousOutline = outline;
                }
            }
            else if (_previousOutline != null)
            {
                print("OnHoverExit");
                Cursor.SetCursor(_cursorDefault, Vector2.zero, CursorMode.ForceSoftware);
                _previousOutline.OutlineWidth = 0;
                _previousOutline = null;
            }
        }
    }
}