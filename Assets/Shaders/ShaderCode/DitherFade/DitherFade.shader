Shader "Custom/DitherFade"
{
    Properties
    {
        _MainTex("_MainTex", 2D) = "white" {}
        _MainTex_TexelSize("_MainTex_TexelSize", Color) = (1,1,1,1)
        _ColorRampTex("_ColorRampTex", 2D) = "bump" {}
        _DissolveValue("_DissolveValue", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        //Base pass
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "DitherFade.cginc"
            ENDCG
        }
    }
}