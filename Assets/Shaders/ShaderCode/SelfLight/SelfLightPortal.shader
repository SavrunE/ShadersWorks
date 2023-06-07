Shader "PortaslRenderPlane/SelfLightPortal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _GrabTexture ("_GrabTexture", 2D) = "white" {}
        _DisplacementPower ("Displacement Power" , Float) = -0.3
        _DisplacementSpeed ("Displacement Speed" , Range(0.1 , 3)) = 1
        //        _MinDistanceDissolve ("_MinDistanceDissolve" , Float) = 0
        //        _MaxDistanceDissolve ("_MaxDistanceDissolve" , Float) = 4
        _Saturation ("Saturation" , Float) = 0
        _DisplacementTex ("_DisplacementTex", 2D) = "white" {}


        _SurfaceColor("_SurfaceColor", Color) = (1,1,1,1)
        _ColorMultipler("_ColorMultipler", Range(0,5)) = 1
        [NoScaleOffset] _NormalMap("_NormalMap", 2D) = "bump" {}
        [NoScaleOffset] _NormalIntensity("_NormalIntensity", Range(0,1)) = 1
        [NoScaleOffset] _NormalIntensitySpeed("_NormalIntensitySpeed", Range(0,50)) = 1
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
            Stencil
            {
                Ref 1
                Comp equal
            }
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "FGLightningPortal.cginc"
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