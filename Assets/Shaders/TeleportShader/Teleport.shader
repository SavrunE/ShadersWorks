Shader "Unlit/Teleport"
{
    Properties
    {
        _ColorA ("ColorA",Color) = (1,1,1,1)
        _ColorB ("ColorB",Color) = (1,1,1,1)
        _ColorStart ("ColorStart",Range(0,1)) = 1
        _ColorEnd ("ColorEnd",Range(0,1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
//            Blend One One
            //  Blend DstColor Zero

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal :TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                // o.uv = UnityObjectToWorldNormal(v.no);
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }


            fixed4 frag(v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.05) * TAU * 5) * 0.5 + 0.5;
                t *= 1 - i.uv.y;
                return t;
            }
            ENDCG
        }
    }
}