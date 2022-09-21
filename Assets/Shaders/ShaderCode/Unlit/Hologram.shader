Shader "Unlit/SpecialFX/Cool Hologram"
{
	Properties
	{
		_MainTex("Texture map", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0,1)) = 0.25
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100

				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha

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
				float4 _TintColor;
				float _Transparency;

				void Unity_Dither_float4(float4 In, float4 ScreenPosition, out float4 Out)
				{
					float2 uv = ScreenPosition.xy * _ScreenParams.xy;
					float DITHER_THRESHOLDS[16] =
					{
						1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
						13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
						4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
						16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
					};
					uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
					Out = In - DITHER_THRESHOLDS[index];
				}

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
					col.a = _Transparency;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
			ENDCG
		}
		}
}
