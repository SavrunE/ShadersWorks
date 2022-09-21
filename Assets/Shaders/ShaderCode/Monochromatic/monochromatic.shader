Shader "Custom/monochromatic"
{
    Properties
    {
        _MainTex("_MainTex", 2D) = "white" {}
        _MainTex_TexelSize("_MainTex_TexelSize", Color) = (1,1,1,1)
        _NoiseTex("_NoiseTex", 2D) = "bump" {}
        _NoiseTex_TexelSize("_NoiseTex_TexelSize", Color) = (1,1,1,1)
        _ColorRampTex("_ColorRampTex", 2D) = "bump" {}
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
            #include "monochromatic.cginc"
            ENDCG
        }
    }
}