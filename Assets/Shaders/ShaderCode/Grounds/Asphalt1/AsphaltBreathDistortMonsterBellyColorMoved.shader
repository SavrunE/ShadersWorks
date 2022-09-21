Shader "Unlit/AsphalMonsterBellyColorMoved"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_RotationSpeed("RotationSpeed", Range(0.1,3)) = 1.16
		_DistortRate("DistortRate", Range(0.1,3)) = 0.43
		_SmoothstapOne("SmoothstapOne", Range(0.1,0.99)) = 0.63
		_SmoothstapTwo("SmoothstapTwo", Range(0.1,0.99)) = 0.12
		_DistortColor("DistortColor", Color) = (1,1,1,1)
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
				half _RotationSpeed;
				half _DistortRate;
				half _SmoothstapOne;
				half _SmoothstapTwo;
				float4 _DistortColor;
				float2 _PointOffset;

				#define TWO_PI 6.28f

				v2f vert(appdata v)
				{
					v2f o;
					//v.vertex.y += sin(v.vertex.z + _Time.y) / 3; //FLYYYYYY
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					/* o = */
					 return o;
				 }

				 fixed4 frag(v2f i) : SV_Target
				 {
					 float2 uv = i.uv - 0.5;
					 float2 distort = uv + _PointOffset;
					 float distance = length(distort);
					 float interpolation = smoothstep(_SmoothstapOne, _SmoothstapTwo, distance);
					 distort *= interpolation * _DistortRate;
					 float angle = _Time.y * _RotationSpeed;
					 float2x2 rotation = float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
					 distort = mul(rotation, distort);
					 i.uv += distort;
					 fixed4 col = tex2D(_MainTex, i.uv);
					 col.rgb += _DistortColor * interpolation;
					 return col;
				 }
				 ENDCG
			 }
		}
}
