Shader "Unlit/Flex"
{
    Properties
    {
        _JumpSpeed("Jump Speed", float) = 10
        _JumpAmplitude("Jump Amplitude", float) = 0.18
        _JumpFrequency("Jump Frequency", float) = 2
        _JumpVerticalOffset("Jump Vertical Offset", float) = 0.33
        _TailExtraSwing("Tail Extra Swing", float) = 0.15
        _LegsAmplitude("Legs Amplitude", float) = 0.10
        _LegsFrequency("Legs Frequency", float) = 10
        _LegsPhaseOffset("Legs Phase Offset", float) = -1
        [NoScaleOffset]
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
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
            half _JumpSpeed;
            half _JumpAmplitude;
            half _JumpFrequency;
            half _JumpVerticalOffset;
            half _TailExtraSwing;
            half _LegsAmplitude;
            half _LegsFrequency;
            half _LegsPhaseOffset;

            v2f vert (appdata v)
            {
                float bodyPos = max((abs(sin(_Time.y * _JumpSpeed + v.uv.x * _JumpFrequency)) - _JumpVerticalOffset), 0);
                float tailMask = smoothstep(0.6, 0.0, v.uv.x) * _TailExtraSwing + _JumpAmplitude;
                bodyPos *= tailMask;
                v.vertex.y += bodyPos;
                
                float legsPos = sin(_Time.y * _JumpSpeed * 2 + _LegsPhaseOffset + v.uv.x * _LegsFrequency) * _LegsAmplitude;
                float legsMask = smoothstep(0.4, 0.1, v.uv.y);
                legsPos *= legsMask;
                v.vertex.z += legsPos;
                
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}