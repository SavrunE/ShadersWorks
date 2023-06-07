Shader "Custom/igoCombineMask"
{
    Properties {
        _BaseMap ("Base Map", 2D) = "white" {}
        _BumpMap ("Bump Map", 2D) = "bump" {}
        _CombineMask ("Combine Mask", 2D) = "white" {}
        _AmountSmothness("AmountSmothness", Range(0, 1)) = 0.5
    }
 
    SubShader {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
                    float3 normal : NORMAL;
				};
 
          	struct v2f
				{
					float2 uv : TEXCOORD0;
                    float3 worldNormal : TEXCOORD1;
					float4 vertex : SV_POSITION;
				};
 
            sampler2D _BaseMap;
            sampler2D _BumpMap;
            sampler2D _CombineMask;
            float _SmoothnessRange = 1.0;
 
            float4 _BaseMap_ST;
 
            float4 _BaseColor;
            float _Metallic;
            float _AmbientOcclusion;
 
            v2f vert (appdata v) {
                v2f o;
					//v.vertex.y += sin(v.vertex.z + _Time.y) / 3; //FLYYYYYY
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _BaseMap);
					/* o = */
					 return o;
            }
 
            fixed4 frag (v2f i) : SV_Target {
                 float2 uv = i.uv - 0.5;
					 //float2 distort = uv + _PointOffset;
					 //float distance = length(distort);
					 //float interpolation = smoothstep(_SmoothstapOne, _SmoothstapTwo, distance);
					 //distort *= interpolation * _DistortRate;
					 //float angle = _Time.y * _RotationSpeed;
					 //float2x2 rotation = float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
					 //distort = mul(rotation, distort);
					 //i.uv += distort;
					 fixed4 col = tex2D(_BaseMap, i.uv);
					 //col.rgb += _DistortColor * interpolation;
					 return col;
                
                //// Sample textures
                fixed4 baseColor = tex2D(_BaseMap, i.uv);
                float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
                //float3 worldNormal = normalize(UnityWorldSpaceNormal(normal, i.worldNormal));
                float metallic = tex2D(_CombineMask, i.uv).r * _Metallic;
                float ambientOcclusion = tex2D(_CombineMask, i.uv).g * _AmbientOcclusion;
                float smoothness = tex2D(_CombineMask, i.uv).b * _SmoothnessRange;
 
                // Calculate final color
                float3 diffuseColor = baseColor.rgb * (1.0 - metallic);
                float3 specularColor = lerp(baseColor.rgb, 1.0, metallic);
                float4 finalColor = float4(lerp(diffuseColor, specularColor, smoothness), baseColor.a);
 
                // Apply ambient occlusion
                finalColor.rgb *= 1.0 - ambientOcclusion;
 
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
