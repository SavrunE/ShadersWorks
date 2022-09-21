Shader "Hidden/Custom/OutLine"
{
    HLSLINCLUDE
    #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

    TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
    float4 _MainTex_TexelSize;
    float _ColorSensitivity;
    float _ColorStrenght;

    TEXTURE2D_SAMPLER2D(_CameraDepthTexture, sampler_CameraDepthTexture);
    float _DepthSensitivity;
    float _DepthStrength;
    
    struct UvData
    {
        float2 leftUV;
        float2 rightUV;
        float2 bottomUV;
        float2 topUV;
    };

    UvData Expand(float2 uv)
    {
        UvData data;
        data.leftUV = uv + float2(-_MainTex_TexelSize.x, 0);
        data.rightUV = uv + float2(_MainTex_TexelSize.x, 0);
        data.bottomUV = uv + float2(0, -_MainTex_TexelSize.y);
        data.topUV = uv + float2(0, _MainTex_TexelSize.y);
        return data;
    }

    float ColorEdge(UvData data)
    {
        float3 col0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, data.leftUV).rgb;
        float3 col1 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, data.rightUV).rgb;
        float3 col2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, data.bottomUV).rgb;
        float3 col3 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, data.topUV).rgb;

        float3 c0 = col1 - col0;
        float3 c1 = col3 - col2;

        float edgeCol = sqrt(dot(c0, c0) + dot(c1, c1));
        return edgeCol > _ColorSensitivity ? _ColorStrenght : 0;
    }

    float DepthEdge(UvData data)
    {
        float depth0 = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, data.leftUV).r;
        float depth1 = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, data.rightUV).r;
        float depth2 = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, data.bottomUV).r;
        float depth3 = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, data.topUV).r;

        depth0 = Linear01Depth(depth0); 
        depth1 = Linear01Depth(depth1); 
        depth2 = Linear01Depth(depth2); 
        depth3 = Linear01Depth(depth3);

        float d0 = depth1 - depth0;
        float d1 = depth3 - depth2;

        float edgeDepth = sqrt(d0 * d0 + d1 * d1);
        return edgeDepth > _DepthSensitivity ? _DepthStrength : 0;
    }

    float4 Frag(VaryingsDefault i) : SV_Target
    {
        float2 uv = i.texcoord;
        float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);

        UvData data = Expand(uv);
        float colorEdge = ColorEdge(data);
        float depthEdge = DepthEdge(data);
        
        return color * (1.0f - depthEdge);
    }
    ENDHLSL

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            // #pragma fragment Frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }
            ENDCG
        }
    }
}