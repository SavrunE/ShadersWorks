Shader "Portal/ScreenCutoutShaderIllumination"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlickSpeed ("_BlickSpeed",Range(0,50)) = 13
        _BlickSaturation("_BlickSaturation",Range(0,20)) = 5
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"
        }
        Lighting Off
        Cull Back
        ZWrite On
        ZTest Less

        Fog
        {
            Mode Off
        }

        Pass
        {
            Stencil
            {
                Ref 1
                Comp equal
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            sampler2D _MainTex;
            float _BlickSpeed;
            float _BlickSaturation;

            #define TAU 6.28318530718


            fixed4 frag(v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * TAU * 8) * 1000;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.05) * TAU * _BlickSpeed) * 0.5 + 0.5;
                t *= 1 - i.uv.y;
                t = t / 20 * _BlickSaturation;

                i.screenPos /= i.screenPos.w;
                fixed4 col = tex2D(_MainTex, float2(i.screenPos.x, i.screenPos.y));

                return col + t;
            }
            ENDCG
        }
    }
}