Shader "Unlit/DigitalInBlack"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ColorMultiplier("ColorMultiplier", Color) = (1,1,1,1)
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
			float4 _ColorMultiplier;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float2 random(float2 p)
			{
				float a = sin(p.x * 615.38 + p.y * 164.157);
				float b = cos(p.x * 424.61 + p.y * 18.874);
				return frac(float2(a, b));
			}

			float voronoi(float2 uv)
			{
				float2 gv = frac(uv);
				float2 id = floor(uv);
				float minD1 = 100;
				float minD2 = 100;

				for (int y = -1; y <= 1; y++)
				{
					for (int x = -1; x <= 1; x++)
					{
						float2 offset = float2(x, y);
						float2 r = random(id + offset);
						float2 p = offset - gv + r;
						float d = abs(p.x) + abs(p.y);
						if (d < minD1)
						{
							minD2 = minD1;
							minD1 = d;
						}
						else if (d < minD2)
						{
							minD2 = d;
						}
					}
				}
				return minD2 - minD1;
			}

			float rand(float n)
			{
				return frac(sin(n) * 43758.5453123);
			}
			float noise1(float p)
			{
				float fl = floor(p);
				float fc = frac(p);
				return lerp(rand(fl), rand(fl + 1.0), fc);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 tex = tex2D(_MainTex, i.uv);
				float2 uv = (i.uv - 0.5) * 10;
				float3 col = 0;

				float v = 0, a = 0.8, f = 1;

				float flicker = noise1(_Time.y) * 0.8 + 0.4;

				for (int i = 0; i < 3; i++)
				{
					float v1 = voronoi(uv * f);
					float v2 = 0;

					if (i > 0)
					{
						v2 = voronoi(uv * f * 0.3 + _Time.y);
						float va = 0, vb = 0;
						va = 1 - smoothstep(0, 0.15, v1);
						vb = 1 - smoothstep(0, 0.18, v2);
						v += va * vb * 5 * a;
					}

					v1 = 1 - smoothstep(0, 0.3, v1);

					v2 = a * noise1(v1 * 5);

					if (i == 0) v += v2 * flicker;
					else v += v2;

					v += v2;
					a *= 0.5;
					f *= 3;
				}

				col = (v * _ColorMultiplier) + tex;
				return float4(col,1);
			}
			ENDCG
		}
	}
}