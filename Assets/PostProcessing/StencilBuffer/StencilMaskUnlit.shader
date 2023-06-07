Shader "Unlit/StencilMaskUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShakePower ("Shake Power" , Range (0, 0.01)) = 0.0025
        _ShakeSpeed ("Shake Speed" , Range (1, 20)) = 13
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque" "Queue" = "Geometry-1"
        }
        LOD 100

        Blend Zero One
        ZWrite Off

        Pass
        {
            Stencil
            {
                Ref 1
                Comp always
                Pass replace
            }
            //            Stencil
            //            {
            //                Ref 1
            //                Comp GEqual
            //            }
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
            float _ShakePower;
            float _ShakeSpeed;
            #define TWO_PI 6.28f

            v2f vert(appdata v)
            {
                v2f o;
                v.vertex.x += sin(v.vertex.z + _Time.y * _ShakeSpeed) * _ShakePower;
                v.vertex.y -= cos(v.vertex.z + _Time.y * _ShakeSpeed) * _ShakePower;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);

                return 0;
            }
            ENDCG
        }
    }
}