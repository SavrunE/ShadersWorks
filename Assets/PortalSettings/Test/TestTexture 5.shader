Shader "Unlit/TestTexture1.0"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
         //distortion
        _RotationSpeed("RotationSpeed", Range(0.1,3)) = 1.16
        _DistortRate("DistortRate", Range(0.1,3)) = 0.43
        _SmoothstapOne("SmoothstapOne", Range(0.1,0.99)) = 0.63
		_SmoothstapTwo("SmoothstapTwo", Range(0.1,0.99)) = 0.12
        _DistortColor("DistortColor", Color) = (1,1,1,1)
        //noize
        _SinAmp("Amplitude", float) = 1.0
		_SinFreq("Frequency", float) = 1.0
		_Octaves("Octaves", float) = 1.0
		_Multiplier("Multiplier", float) = 1.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            Stencil
            {
                Ref 1
                Comp equal
            }
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#include "FGLightningPortal.cginc"
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT; // xyz - tangent directions, w - tangent sign
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 tangent : TEXCOORD2;
                float3 bitangent : TEXCOORD3;
                float3 wPos : TEXCOORD4;
                float4 screenPos : TEXCOORD6;
                float4 color : COLOR;
                float4 grabPos : TEXCOORD7;
                LIGHTING_COORDS(5, 6)
            };

             //distortion
            sampler2D _MainTex;
            float4 _MainTex_ST;
            half _RotationSpeed;
            half _DistortRate;
            half _SmoothstapOne;
			half _SmoothstapTwo;
            float4 _DistortColor;

            //noize
            float _SinAmp;
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
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                     //distortion
                     float2 uv = i.uv - 0.5;
					 float2 distort = uv;
					 float distance = length(uv);
					 float interpolation = smoothstep(_SmoothstapOne, _SmoothstapTwo, distance);
					 distort *= interpolation * _DistortRate;
					 float angle = _Time.y * _RotationSpeed;
					 float2x2 rotation = float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
					 distort = mul(rotation, distort);
					 i.uv += distort;
					 fixed4 col = tex2D(_MainTex, i.uv);
					 col.rgb += _DistortColor * interpolation;


                    //noize
                    uv = i.uv;
					//float3 col = 0.0;

					float q = fbm(uv);
					float r = fbm(uv + q + _Time.y * 0.5);
					float f = fbm(uv + r);

					//col = lerp(float3(0.85, 0.01, 0.47),
					//	float3(0.37, 0.67, 0.5),
					//	clamp(f * f * 3.0, 0.0, 1.0));
					col *= f;
					col *= 1.9;

					return col;

                //i.screenPos /= i.screenPos.w;
                //fixed4 tex = tex2D(_MainTex, float2(i.screenPos.x, i.screenPos.y));
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //return col;
            }
            ENDCG
        }
    }
}