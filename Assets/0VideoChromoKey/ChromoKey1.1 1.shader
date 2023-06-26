Shader "IgorCustom/ChromoKey1.11"
{
    Properties
    {
        [NoScaleOffset]_BaseMap("Texture2D", 2D) = "white" {}
        Color_4191095A("KeyColor", Color) = (0.07843138, 0.6039216, 0.04313726, 1)
        Vector1_84B7BD56("Threshold", Float) = 0.4
        Vector1_11E1B4BD("Fuzziness", Float) = 0.1
        Vector1_a188cb0e3ebc430892b6caa9749ab8fe("Alpha", Float) = 0.9
        Vector1_49e144ba94ff45d69d9e2f857e8792d3("AlphaChangePower", Float) = 0.15
        Vector1_c109ebef38e94e83833c672705e0b813("AlphaChangeSpeed", Float) = 4.02
        Color_97b43704a5214c648f22520c94a0138c("Color", Color) = (1, 1, 1, 0)
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_2c5ab0203f6a4e6fb68879fa5c0766d9_Out_0 = Color_97b43704a5214c648f22520c94a0138c;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float3 _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2;
            Unity_Subtract_float3(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3.xxx), _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2);
            float3 _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2;
            Unity_Multiply_float((_Property_2c5ab0203f6a4e6fb68879fa5c0766d9_Out_0.xyz), _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2, _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.BaseColor = _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2;
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
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
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
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
            float4 uv0 : TEXCOORD0;
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
            float3 TimeParameters;
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
            float4 interp2 : TEXCOORD2;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_2c5ab0203f6a4e6fb68879fa5c0766d9_Out_0 = Color_97b43704a5214c648f22520c94a0138c;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float3 _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2;
            Unity_Subtract_float3(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3.xxx), _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2);
            float3 _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2;
            Unity_Multiply_float((_Property_2c5ab0203f6a4e6fb68879fa5c0766d9_Out_0.xyz), _Subtract_138ca4ee156a3a83b806f3a267ac8577_Out_2, _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.BaseColor = _Multiply_7a93ed935cfd49b9af84a0c348fd5341_Out_2;
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
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
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
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
            float3 TimeParameters;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1
        );    Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
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
            float4 uv0 : TEXCOORD0;
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
            float3 TimeParameters;
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
            float4 interp2 : TEXCOORD2;
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

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
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
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
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
        float4 _BaseMap_TexelSize;
        float4 Color_4191095A;
        float Vector1_84B7BD56;
        float Vector1_11E1B4BD;
        float Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
        float Vector1_49e144ba94ff45d69d9e2f857e8792d3;
        float Vector1_c109ebef38e94e83833c672705e0b813;
        float4 Color_97b43704a5214c648f22520c94a0138c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
        {
            float Distance = distance(MaskColor, In);
            Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
        }

        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            float4 _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.tex, _Property_5115f7afb028f982b0c0883d41d8dc47_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.r;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.g;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.b;
            float _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_A_7 = _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_RGBA_0.a;
            float3 _Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0 = float3(_SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_R_4, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_G_5, _SampleTexture2D_f706acbc2ef1dc839d2ea6b2e93227de_B_6);
            float4 _Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0 = Color_4191095A;
            float _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0 = Vector1_84B7BD56;
            float _Property_39fcd11c278ac58595a8399c79d31da4_Out_0 = Vector1_11E1B4BD;
            float _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3;
            Unity_ColorMask_float(_Vector3_a25f3b8a91534787a1ecd5232714899f_Out_0, (_Property_89fd222daa213282a55e67b2ebe7e3d5_Out_0.xyz), _Property_d384d8f98b89a989a82fb2a7736b0112_Out_0, _ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _Property_39fcd11c278ac58595a8399c79d31da4_Out_0);
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1;
            float _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors = float (1);    
            Unity_InvertColors_float(_ColorMask_b782c178915803859dc56cc2f5633b08_Out_3, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_InvertColors, _InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1);
            float _Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0 = Vector1_a188cb0e3ebc430892b6caa9749ab8fe;
            float _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0 = Vector1_c109ebef38e94e83833c672705e0b813;
            float _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_641f267e8c914610b2c41b25d7e5dc80_Out_0, _Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2);
            float _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1;
            Unity_Sine_float(_Multiply_c8c540a456cb4426b0f4d4f6c15c79bb_Out_2, _Sine_4a3b104b38164313beb127d87fc3eab1_Out_1);
            float _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0 = Vector1_49e144ba94ff45d69d9e2f857e8792d3;
            float _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2;
            Unity_Multiply_float(_Sine_4a3b104b38164313beb127d87fc3eab1_Out_1, _Property_7a6912df2acd4ee4856acf1367d445a7_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2);
            float _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2;
            Unity_Add_float(_Property_4a31eef0e3bf4d789fceb491f78ee5ad_Out_0, _Multiply_7a01b97de6bb4cdeb2a7fe0a59b7dbf4_Out_2, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2);
            float _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            Unity_Multiply_float(_InvertColors_76911ff5d91e0b878daef6f1a7ca5089_Out_1, _Add_76b9d12f650c4a5e8eabef5a3f1ac68a_Out_2, _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2);
            surface.Alpha = _Multiply_dcabd0cfeb2a4cd2aa07e3f0cf320ad1_Out_2;
            surface.AlphaClipThreshold = 0.25;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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