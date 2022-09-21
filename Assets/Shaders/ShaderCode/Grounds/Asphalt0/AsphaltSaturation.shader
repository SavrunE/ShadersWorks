Shader "Unlit/AsphaltUnlitShaderSaturation"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ColorMultipler("ColorMultipler", Color) = (1,1,1,1)
		_Saturation("Saturation", Range(0,3)) = 0.71
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					/* o = */
					 return o;
				 }

				 fixed4 frag(v2f i) : SV_Target
				 {
					 // sample the texture
					 fixed4 col = tex2D(_MainTex, i.uv);
					 col = lerp(_ColorMultipler, col, (i.uv.x - i.uv.y / 2) * _Saturation);
					 return col;
				 }
				 ENDCG
			 }
		}
}
