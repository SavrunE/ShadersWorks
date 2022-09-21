Shader "Custom/SelfLightDistDissolve"
{
    Properties
    {
        _MainTex("_BaseMap", 2D) = "white" {}
        _SurfaceColor("_SurfaceColor", Color) = (1,1,1,1)
        _ColorMultipler("_ColorMultipler", Range(0,5)) = 1
        [NoScaleOffset] _NormalMap("_NormalMap", 2D) = "bump" {}
        [NoScaleOffset] _NormalIntensity("_NormalIntensity", Range(0,1)) = 1
        [NoScaleOffset] _HeightMap("_HeightMap", 2D) = "gray" {}
        _DisplacementStrenght("_HeightIntensity", Range(0,0.2)) = 0.1
        [NoScaleOffset] _CubeMap("_CubeMap", cube) = "" {}
        _SpecularIntensity("_SpecularIntensity", Range(0,3)) = 0.5
        _Gloss("_Gloss", Range(0,1)) = 1
        _LightOffsetX("_LightOffsetX", Range(-3,3)) = 0
        _LightOffsetY("_LightOffsetY", Range(-3,3)) = 0
        _LightOffsetZ("_LightOffsetZ", Range(-3,3)) = 0
        _LightColor("_LightColor", Color) = (1,1,1,1)
        _LightColorBoost("_LightBoost", Range(0,3)) = 1
        _MinDistanceDissolve("_MinDistanceDissolve", Range(0,3)) = 1
        _MaxDistanceDissolve("_MaxDistanceDissolve", Range(1,10)) = 2
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
            #include "FGLightningDistanceDissolve.cginc"
            ENDCG
        }
        //        Add pass
//        Pass
//        {
//            Tags
//            {
//                "LightMode" = "UniversalForward"
//            }
//            //                    Blend One One // src * 1 + dst * 1
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #pragma multy_compile_fwdadd
//            #include "DitherFade.cginc"
//            ENDCG
//        }
    }
}