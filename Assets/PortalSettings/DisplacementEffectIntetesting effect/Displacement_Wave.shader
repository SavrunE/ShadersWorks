Shader "Displacement/Displacement_Wave_First"
{
    Properties
    {
        [PerRendererData]
        _MainTex ("Main Texture", 2D) = "white" {}
        _GrabTexture ("_GrabTexture", 2D) = "white" {}
        _Color ("Color" , Color) = (1,1,1,1)
        _DisplacementPower ("Displacement Power" , Float) = 0
        _DisplacementTex ("Displacement Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Cull Off
        //        Blend SrcAlpha OneMinusSrcAlpha
        Blend Off
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
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float4 grabPos : TEXCOORD1;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            sampler2D _GrabTexture;
            float _DisplacementPower;
            sampler2D _DisplacementTex;

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

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 displPos = tex2D(_DisplacementTex, i.uv);
                float2 offset = (displPos.xy * 2 - 1) * _DisplacementPower * displPos.a;

                fixed4 grabColor = tex2D(_GrabTexture, i.grabPos.xy + offset);
                fixed4 texColor = tex2D(_MainTex, i.uv) * i.color;
                return grabColor;
            }
            ENDCG
        }
    }
}