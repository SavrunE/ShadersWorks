Shader "Unlit/NoChangeCollor"
{
    Properties
    {
        [NoScaleOffset] Texture2D_38576cfb41a841dfb3dd8c5757edd376("Albedo", 2D) = "white" {}
        Color_957c8a7898c44e18908e3871fda6ce73("Color", Color) = (0, 0, 0, 0)
        Vector1_185f2a2c6b5b420baa8c6901a7f70b25("Saturation", Range(0, 4)) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Geometry"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.texCoord0 = input.interp0.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_da5017eb50a149f4877f4ffe644ff884_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
    float4 _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0 = SAMPLE_TEXTURE2D(_Property_da5017eb50a149f4877f4ffe644ff884_Out_0.tex, _Property_da5017eb50a149f4877f4ffe644ff884_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_R_4 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.r;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_G_5 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.g;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_B_6 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.b;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_A_7 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.a;
    float4 _Property_035a10b1705048b293fc5d43bcc87cdb_Out_0 = Color_957c8a7898c44e18908e3871fda6ce73;
    float4 _Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2;
    Unity_Multiply_float(_SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0, _Property_035a10b1705048b293fc5d43bcc87cdb_Out_0, _Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2);
    float _Property_1a8b27be875e45ea83a9d383c9d9b04d_Out_0 = Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
    float4 _Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2;
    Unity_Multiply_float(_Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2, (_Property_1a8b27be875e45ea83a9d383c9d9b04d_Out_0.xxxx), _Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2);
    surface.BaseColor = (_Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2.xyz);
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.normalWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.normalWS = input.interp0.xyz;
        output.tangentWS = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Geometry"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.texCoord0 = input.interp0.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_da5017eb50a149f4877f4ffe644ff884_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
    float4 _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0 = SAMPLE_TEXTURE2D(_Property_da5017eb50a149f4877f4ffe644ff884_Out_0.tex, _Property_da5017eb50a149f4877f4ffe644ff884_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_R_4 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.r;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_G_5 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.g;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_B_6 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.b;
    float _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_A_7 = _SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0.a;
    float4 _Property_035a10b1705048b293fc5d43bcc87cdb_Out_0 = Color_957c8a7898c44e18908e3871fda6ce73;
    float4 _Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2;
    Unity_Multiply_float(_SampleTexture2D_64a59b4ecb9145ffb9a7123b2727fb02_RGBA_0, _Property_035a10b1705048b293fc5d43bcc87cdb_Out_0, _Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2);
    float _Property_1a8b27be875e45ea83a9d383c9d9b04d_Out_0 = Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
    float4 _Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2;
    Unity_Multiply_float(_Multiply_4e0b5910b0a8410d94c866a71923714e_Out_2, (_Property_1a8b27be875e45ea83a9d383c9d9b04d_Out_0.xxxx), _Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2);
    surface.BaseColor = (_Multiply_8bc68891593941f4b936447d2fdd77b3_Out_2.xyz);
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.normalWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Back
    Blend One Zero
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.normalWS;
        output.interp1.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
        output.normalWS = input.interp0.xyz;
        output.tangentWS = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
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
float4 Texture2D_38576cfb41a841dfb3dd8c5757edd376_TexelSize;
float4 Color_957c8a7898c44e18908e3871fda6ce73;
float Vector1_185f2a2c6b5b420baa8c6901a7f70b25;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_38576cfb41a841dfb3dd8c5757edd376);
SAMPLER(samplerTexture2D_38576cfb41a841dfb3dd8c5757edd376);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        FallBack "Hidden/Shader Graph/FallbackError"
}