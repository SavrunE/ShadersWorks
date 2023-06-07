using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalWave : MonoBehaviour
{
    private float _elapsedTime;
    private SpriteRenderer _renderer;

    public float Duration;
    [Space] public AnimationCurve ScaleProgress;
    public Vector3 ScalePower;
    [Space] public AnimationCurve PropertyProgress;
    public float PropertyPower;
    [Space] public AnimationCurve AlphaProgress;

    private MaterialPropertyBlock _propertyBlock;
    
    private void Start()
    {
        _renderer = GetComponent<SpriteRenderer>();
        _propertyBlock = new MaterialPropertyBlock();
    }

    private void OnEnable()
    {
        _elapsedTime = 0f;
    }

    void Update()
    {
        if (_elapsedTime < Duration)
        {
            var progress = _elapsedTime / Duration;

            var scale = ScaleProgress.Evaluate(progress) * ScalePower;
            var property = PropertyProgress.Evaluate(progress) * PropertyPower;
            var alpha = AlphaProgress.Evaluate(progress);

            transform.localScale = scale;
            // _renderer.material.SetFloat("_DisplacementPower", property);
            _renderer.GetPropertyBlock(_propertyBlock);
            _propertyBlock.SetFloat("_DisplacementPower", property);
            _renderer.SetPropertyBlock(_propertyBlock);
            var color = _renderer.color;
            color.a = alpha;
            _renderer.color = color;

            _elapsedTime += Time.deltaTime;
        }
        else
        {
            _elapsedTime = 0;
        }
    }
}