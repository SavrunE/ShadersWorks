using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(OutlineRenderer), PostProcessEvent.AfterStack, "Custom/Outline")]
public class OutLinePP : PostProcessEffectSettings
{
    [Range(0f, 0.3f), Tooltip("Color usage threshold.")]
    public FloatParameter ColorSensitivity = new FloatParameter { value = 0.1f };

    [Range(0f, 1.0f), Tooltip("Strenght of color.")]
    public FloatParameter ColorStrenght = new FloatParameter { value = 1.0f };
}

public sealed class OutlineRenderer : PostProcessEffectRenderer<OutLinePP>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/OutLine"));
        sheet.properties.SetFloat("_ColorSensitivity", settings.ColorSensitivity);
        sheet.properties.SetFloat("_ColorStrenght", settings.ColorStrenght);
        //Set parameters
        context.command.BlitFullscreenTriangle(context.source, context.destination,
            sheet, 0);
    }
}