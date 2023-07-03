Shader "Unlit/igChromoKey"
{
    Properties
    {
        _MainTex("Texture2D", 2D) = "white" {}
        _KeyColor("KeyColor", Color) = (0.07843138, 0.6039216, 0.04313726, 0)
        _Threshold("Threshold", Float) = 0.4
        _Fuzziness("Fuzziness", Float) = 0.1
        _AlphaChangePower("AlphaChangePower", Float) = 0.15
        _AlphaChangeSpeed("AlphaChangeSpeed", Float) = 4.02
        _Color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZTest LEqual
            ZWrite Off

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _KeyColor;
            float _Threshold;
            float _Fuzziness;
            float _AlphaChangeSpeed;
            float _AlphaChangePower;
            float4 _Color;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);

                fixed4 colormask;
                fixed3 tex3 = float3(tex.r,tex.g,tex.b);
                fixed3 key = float3(_KeyColor.r,_KeyColor.g,_KeyColor.b);
                float Distance = distance(key, tex3);
                colormask = saturate(1 - (Distance - _Threshold) / max(_Fuzziness, 1e-5));

                float3 subtrack = tex3 - colormask;

                float3 mainColor = _Color * subtrack;

                float4 invertColor = float4(1,0,0,0);
                float4 invertColors = abs(invertColor - colormask);
                
                float speed = _Time.y * _AlphaChangeSpeed;
                speed = sin(speed);
                float alphaPower = speed *  _AlphaChangePower;
                
                float alpha = _Color.a;
                alpha = alpha * invertColors + alphaPower;
                clip(alpha - 0.25);

                return float4(mainColor, alpha);
            }
            ENDCG
        }
    }
}
