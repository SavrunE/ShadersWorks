Shader "Interactive/Illumination"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _isBlink ("_isBlink",Range(0,1)) = 0
        _BlickSpeed ("_BlickSpeed",Range(0,50)) = 13
        _BlickSaturation("_BlickSaturation",Range(0,20)) = 5
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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
            float _isBlink;
            float _BlickSpeed;
            float _BlickSaturation;

            #define TAU 6.28318530718

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float t = 0;

                if (_isBlink == 1)
                {
                    float xOffset = cos(i.uv.x * TAU * 8) * 1000;
                    t = cos((i.uv.y + xOffset - _Time.y * 0.05) * TAU * _BlickSpeed) * 0.5 + 0.5;
                    t *= 1 - i.uv.y;
                    t = t / 20 * _BlickSaturation;
                }

                fixed4 col = tex2D(_MainTex, i.uv);

                return col + t;
            }
            ENDCG
        }
    }
}