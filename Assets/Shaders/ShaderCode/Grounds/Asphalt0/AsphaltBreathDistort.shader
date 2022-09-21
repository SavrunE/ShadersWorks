Shader "Unlit/AsphaltUnlitShaderDistort"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ColorMultipler("ColorMultipler", Color) = (1,1,1,1)
		_Saturation("Saturation", Range(0.1,3)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
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
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _ColorMultipler;
				half _Saturation;

				#define TWO_PI 6.28f

				v2f vert(appdata v)
				{
					v2f o;
					v.vertex.y += sin(v.vertex.z + _Time.y) / 3; //FLYYYYYY
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					/* o = */
					 return o;
				 }

				 fixed4 frag(v2f i) : SV_Target
				 {
					 // sample the texture
					/*  i.uv.y += sin(i.uv.x * TWO_PI/2 + _Time.y) / 5+.2 * i.uv.y;
					 fixed4 col = tex2D(_MainTex, i.uv);
					 col = col * _Saturation * _ColorMultipler;*/
					 //return col;

					 float2 uv = i.uv - 0.5;
					 float2 distort = uv;
					 float distance = length(uv);
					 float interpolation = smoothstep(0.4, 0.34, distance);
					 distort *= interpolation * _Saturation;
					 i.uv += distort;
					 fixed4 col = tex2D(_MainTex, i.uv);
					 return col;
				 }
				 ENDCG
			 }
		}
}
