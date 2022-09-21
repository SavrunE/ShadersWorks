Shader "Templates/FBMGoodNoiseTemplate"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ColorMultipler("ColorMultipler", Color) = (1,1,1,1)
		_StartColor("StartColor", Color) = (1,1,1,1)
		_EndColor("EndColor", Color) = (1,1,1,1)
		_Saturation("Saturation", Range(0.1, 5)) = 1
		_Tiling("Tiling", float) = 10
		_SinFreq("Frequency", Range(0.1,1)) = 0.5
		_Octaves("Octaves", Range(1.01,2)) = 1.5
		_Multiplier("Multiplier", float) = 1.0
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
				float4 _ColorMultipler;
				float4 _StartColor;
				float4 _EndColor;
				float _Saturation;
				float _Tiling;
				float _SinFreq;
				float _Octaves;
				float _Multiplier;

				float random(float2 p)
				{
					float d = dot(p, float2(11.52346, 54.6341));
					float s = sin(d);
					return frac(s * 65124.6234125);
				}

				float noise(float2 uv)
				{
					float2 id = floor(uv);
					float2 f = frac(uv);

					float a = random(id);
					float b = random(id + float2(1.0, 0.0));
					float c = random(id + float2(0.0, 1.0));
					float d = random(id + float2(1.0, 1.0));

					float2 u = f * f * (3.0 - 2.0 * f); // smoothstep(0.0, 1.0, f); 

					float x1 = lerp(a, b, u.x);
					float x2 = lerp(c, d, u.x);
					return lerp(x1, x2, u.y);
				}

				float fbm(float2 p)
				{
					float result = 0.0;
					float amplitude = 0.5;
					float offset = 50.0;
					float2x2 rot = float2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
					for (int i = 0; i < _Octaves; i++)
					{
						result += amplitude * noise(p);
						p = mul(rot, p) * 2.0 + offset;
						amplitude *= _Multiplier;
					}
					return result;
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
					fixed2 uv = i.uv * _Tiling;
					float3 col = 0.0;

					float q = fbm(uv);
					float r = fbm(uv + q + _Time.y * _SinFreq);
					float f = fbm(uv + r);
					col = lerp(_StartColor, _EndColor,	clamp(f * f * 3.0, 0.0, 1.0));
					//col = tex2D(_MainTex, i.uv);
					col = col * _Saturation * _ColorMultipler;
					col *= f * tex2D(_MainTex, i.uv);
					return float4(col, 1.0);
				}
				ENDCG
			}
		}
}
