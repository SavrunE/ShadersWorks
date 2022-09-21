Shader "Unlit/NoizeVoronov"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_RandomMultiplier("_RandomMultiplier", Range(1,100000)) = 24667
		_OffsetX("_OffsetX", Range(1,1000)) = 603
		_OffsetY("_OffsetY", Range(1,1000)) = 423
		_LineWidth("_LineWidth", Range(0.1,1)) = 0.5
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
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				half _RandomMultiplier;
				float _OffsetX;
				float _OffsetY;
				float _LineWidth;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				float random(float2 p)
				{
					float d = dot(p, float2(11.52346, 54.6341));
					float s = sin(d);
					return frac(s * 65124.6234125);
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float2 uv = i.uv * 10;
					float2 id = floor(uv);
					float2 gv = frac(uv);

					float color = 0;

					float resultDistance = 1.0;
					float resultPoint = 0.0;
					for (int y = -1; y <= 1; y++)
					{
						for (int x = -1; x <= 1; x++)
						{
							float2 offset = float2(x, y);
							float2 p = random(id + offset);

							float distance = length(p - gv + offset);

							if (distance < resultDistance)
							{
								resultDistance = distance;
								resultPoint = p;
							}
						}
					}

					color += resultDistance;
					//color += random(resultPoint);

					return fixed4(color, color, color, 1);
				}
				ENDCG
			}
		}
}
