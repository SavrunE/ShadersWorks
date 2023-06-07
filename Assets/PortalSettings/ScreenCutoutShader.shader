Shader "Portal/ScreenCutoutShaderBlick"
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
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
                float4 color : COLOR;
                float4 grabPos : TEXCOORD2;
                float3 wPos : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeScreenPos(o.vertex);
                o.grabPos /= o.grabPos.w;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _DisplacementTex;
            sampler2D _GrabTexture;
            float _DisplacementPower;
            float _DisplacementSpeed;
            float _Saturation;
            // float _MinDistanceDissolve;
            // float _MaxDistanceDissolve;
            #define TWO_PI 6.28f

            void Unity_Distance_float4(float4 A, float4 B, out float Out)
            {
                Out = distance(A, B);
            }

            void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                //distance
                // float noiseLum;
                // float distance = 0;
                // float remap = 0;
                // float2 min_max = float2(_MinDistanceDissolve, _MaxDistanceDissolve);
                // // Unity_Dither_float(1, float4(i.vertex.xy / i.vertex.w, 0, 0), noiseLum);
                // Unity_Distance_float4(float4(_WorldSpaceCameraPos, 0), float4(i.wPos, 0), distance);
                // Unity_Remap_float4(distance, min_max, float2(0, 1), remap);
                // // clip(remap - noiseLum);
                // _DisplacementPower *= distance/10;

                _DisplacementPower *= sin(i.uv.x * TWO_PI/2 + _Time.y * _DisplacementSpeed) / 5+.2 * i.uv.y;
                
                i.screenPos /= i.screenPos.w;
                fixed4 tex = tex2D(_MainTex, float2(i.screenPos.x, i.screenPos.y));

                fixed4 displPos = tex2D(_DisplacementTex, i.uv);
                float2 offset = (displPos.xy * 2 - 1) * _DisplacementPower * displPos.a;

                fixed4 texColor = tex2D(_MainTex, i.uv + offset) * i.color;
                fixed4 grabColor = tex2D(_GrabTexture, i.grabPos.xy + offset);

                fixed s = step(grabColor, 0.5);
                fixed4 color = s * (2 * grabColor * texColor) +
                    (1 - s) * (1 - 2 * (1 - texColor) * (1 - grabColor));
                color = lerp(grabColor, color, texColor.a);

                return tex * color * _Saturation;
            }
            ENDCG
        }
    }
}