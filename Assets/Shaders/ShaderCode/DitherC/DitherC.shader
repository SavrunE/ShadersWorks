Shader "Unlit/Dither"
{
    Properties
    {
        [NoScaleOffset] Texture2D_a236e738aab34dcc8a01959e8acf5abd("Albedo", 2D) = "white" {}
        [NoScaleOffset]Texture2D_e672aa02e6744f139f8de5b34c2ecac5("Normal", 2D) = "white" {}
        [NoScaleOffset]Texture2D_fc98ef20aff048d2b311b723b3643dfb("Metallic", 2D) = "white" {}
        Color_6bd3d743ac044d5085294573e3c66c76("Color", Color) = (0.6117647, 0.5882353, 0.5882353, 0)
        Vector1_d613676ed4704b579eaa9297b5eefcb5("Dissolve", Range(0, 1)) = 0
        Vector1_b54f9f7d984c41908fab34deea013e2e("MinDistance", Float) = 0
        Vector1_8b83fd10ae224c748e1bf29e15c770fd("MaxDistance", Float) = 0
    }
        SubShader
        {
            Tags
            {
                // RenderPipeline: <None>
                "RenderType" = "Opaque"
                "Queue" = "Geometry"
            }
            Pass
            {
                // Name: <None>
                Tags
                {
                // LightMode: <None>
            }

            // Render State
            // RenderState: <None>

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define VARYINGS_NEED_POSITION_WS
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_PREVIEW
        #define SHADERGRAPH_PREVIEW
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariables.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings(Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings(PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float4 Texture2D_a236e738aab34dcc8a01959e8acf5abd_TexelSize;
    float4 Texture2D_e672aa02e6744f139f8de5b34c2ecac5_TexelSize;
    float4 Texture2D_fc98ef20aff048d2b311b723b3643dfb_TexelSize;
    float4 Color_6bd3d743ac044d5085294573e3c66c76;
    float Vector1_d613676ed4704b579eaa9297b5eefcb5;
    float Vector1_b54f9f7d984c41908fab34deea013e2e;
    float Vector1_8b83fd10ae224c748e1bf29e15c770fd;
    CBUFFER_END

        // Object and Global properties
        TEXTURE2D(Texture2D_a236e738aab34dcc8a01959e8acf5abd);
        SAMPLER(samplerTexture2D_a236e738aab34dcc8a01959e8acf5abd);
        TEXTURE2D(Texture2D_e672aa02e6744f139f8de5b34c2ecac5);
        SAMPLER(samplerTexture2D_e672aa02e6744f139f8de5b34c2ecac5);
        TEXTURE2D(Texture2D_fc98ef20aff048d2b311b723b3643dfb);
        SAMPLER(samplerTexture2D_fc98ef20aff048d2b311b723b3643dfb);

        // Graph Functions

    void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
    {
        float2 uv = ScreenPosition.xy * _ScreenParams.xy;
        float DITHER_THRESHOLDS[16] =
        {
            1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
            13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
            4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
            16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
        };
        uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
        Out = In - DITHER_THRESHOLDS[index];
    }

    // Graph Vertex
    // GraphVertex: <None>

    // Graph Pixel
    struct SurfaceDescription
{
    float4 Out;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2;
    Unity_Dither_float(1, float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2);
    surface.Out = all(isfinite(_Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2)) ? half4(_Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2, _Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2, _Dither_bc980bcc210f461c8f8a07eea956a4d8_Out_2, 1.0) : float4(1.0f, 0.0f, 1.0f, 1.0f);
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewVaryings.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewPass.hlsl"

    ENDHLSL
}
        }
            FallBack "Hidden/Shader Graph/FallbackError"
}