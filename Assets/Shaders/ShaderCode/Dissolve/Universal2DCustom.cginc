#ifndef UNIVERSAL_FALLBACK_2D_INCLUDED
#define UNIVERSAL_FALLBACK_2D_INCLUDED
#include "LitInputCustom.cginc"
#include "UnityCG.cginc"

struct Attributes
{
    float4 positionOS       : POSITION;
    float2 uv               : TEXCOORD0;
};

struct Varyings
{
    float2 uv        : TEXCOORD0;
    float3 wPos : TEXCOORD1;
    float4 vertex : SV_POSITION;
};

Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;

    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    output.vertex = vertexInput.positionCS;
    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.wPos = mul(unity_ObjectToWorld, output.vertex);
    
    return output;
}

half4 frag(Varyings input) : SV_Target
{
    half2 uv = input.uv;
    half4 texColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
    half3 color = texColor.rgb * _BaseColor.rgb;
    half alpha = texColor.a * _BaseColor.a;
    AlphaDiscard(alpha, _Cutoff);
    
    // float noiseLum;
    // float distance = 0; 
    // float4 remap = 0;
    // float2 min_max = float2(_MinDistanceDissolve, _MaxDistanceDissolve);
    // Unity_Dither_float(1, float4(input.vertex.xy / input.vertex.w, 0, 0), noiseLum);
    // Unity_Distance_float4(float4(_WorldSpaceCameraPos, 0), float4(input.wPos, 0), distance);
    // Unity_Remap_float4(distance, min_max, float2(0, 1), remap);
    // clip(remap - noiseLum);

    // float noiseLum;
    // // Unity_Dither_float(1, float4(input.vertex.xy/input.vertex.w, 0, 0), noiseLum);///
    // Unity_Dither_float(1, float4(input.vertex.xy/input.vertex.w, 0, 0), noiseLum);///
    // clip(noiseLum < 0.5 ? -1 : 1);
    
#ifdef _ALPHAPREMULTIPLY_ON
    color *= alpha;
#endif
    return half4(color, alpha);
}

#endif
