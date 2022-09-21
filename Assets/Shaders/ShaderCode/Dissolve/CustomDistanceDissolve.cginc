#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT; // xyz - tangent directions, w - tangent sign
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 bitangent : TEXCOORD3;
    float3 wPos : TEXCOORD4;
    LIGHTING_COORDS(5, 6)
};

sampler2D _MainTex;
sampler2D _NormalMap;
sampler2D _HeightMap;
sampler2D _Specular;
float4 _MainTex_ST;
float4 _SurfaceColor;
float4 _LightColor;
float _ColorMultipler;
float _NormalIntensity;
float _DisplacementStrenght;
float _LightColorBoost;
float _Gloss;
float _LightOffsetX;
float _LightOffsetY;
float _LightOffsetZ;
float _SpecularIntensity;
float _MinDistanceDissolve;
float _MaxDistanceDissolve;
samplerCUBE _CubeMap;

#define TAU 6.28318530718

float2 Rotate(float2 v, float angRad)
{
    float ca = cos(angRad);
    float sa = sin(angRad);
    return float2(ca * v.x - sa * v.y, sa * v.x + ca * v.y);
}

float2 DirToRectliner(float3 dir)
{
    float x = atan2(dir.z, dir.x) / TAU + 0.5;
    float y = dir.y * 0.5 + 0.5;
    return float2(x, y);
}

v2f vert(appdata v)
{
    v2f o;

    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    float height = tex2Dlod(_HeightMap, float4(o.uv, 0, 0)).x * 2 - 1;
    v.vertex.xyz += v.normal * height * _DisplacementStrenght;

    o.vertex = UnityObjectToClipPos(v.vertex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.bitangent = cross(o.normal, o.tangent);
    o.bitangent *= v.tangent.w * unity_WorldTransformParams.w; //mirror fix

    o.wPos = mul(unity_ObjectToWorld, v.vertex);
    TRANSFER_VERTEX_TO_FRAGMENT(o)
    return o;
}

float3 NoramalMapCalculate(v2f i)
{
    float3 tangentSpaceNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
    tangentSpaceNormal = normalize(lerp(float3(0, 0, 1), tangentSpaceNormal, _NormalIntensity));

    float3x3 mtxTangToWorld = {
        i.tangent.x, i.bitangent.x, i.normal.x,
        i.tangent.y, i.bitangent.y, i.normal.y,
        i.tangent.z, i.bitangent.z, i.normal.z
    };

    float3 norm = mul(mtxTangToWorld, tangentSpaceNormal);
    return norm;
};

void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
{
    float2 uv = ScreenPosition.xy * _ScreenParams.xy;
    float DITHER_THRESHOLDS[16] =
    {
        1.0 / 17.0, 9.0 / 17.0, 3.0 / 17.0, 11.0 / 17.0,
        13.0 / 17.0, 5.0 / 17.0, 15.0 / 17.0, 7.0 / 17.0,
        4.0 / 17.0, 12.0 / 17.0, 2.0 / 17.0, 10.0 / 17.0,
        16.0 / 17.0, 8.0 / 17.0, 14.0 / 17.0, 6.0 / 17.0
    };
    uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
    Out = In - DITHER_THRESHOLDS[index];
}

void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Distance_float4(float4 A, float4 B, out float Out)
{
    Out = distance(A, B);
}

float3 ReflectCalculate(v2f i, float3 N)
{
    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
    float3 viewReflect = reflect(-V, normalize(i.normal));
    float mip = (1 - _Gloss) * 6;
    // return texCUBE(_CubeMap, float4(DirToRectliner(viewReflect), mip, mip)).xyz * _SpecularIntensity;
    return texCUBE(_CubeMap, viewReflect).xyz * _SpecularIntensity;
};

fixed4 frag(v2f i) : SV_Target
{
    float3 tex = tex2D(_MainTex, i.uv) * _ColorMultipler;
    float3 N = NoramalMapCalculate(i);
    float3 diffuseIBL = ReflectCalculate(i, N);
    float4 light = _LightColor * _LightColorBoost;
    float3 L = normalize(_WorldSpaceCameraPos - i.wPos + float3(_LightOffsetX, _LightOffsetY, _LightOffsetZ));
    float attenuation = LIGHT_ATTENUATION(i);
    float3 lambert = saturate(dot(N, L));
    float3 diffuseLight = light * attenuation * lambert;
    
    //specular lightning
    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
    float3 H = normalize(L + V);
    float3 specularLight = saturate(dot(H, N) * (lambert > 0)); //saturate(dot(H, N) * (lambert > 0))
    float specularExponent = exp2(_Gloss * 2) + 1; //exp2(_Gloss * 6) + 1
    specularLight = pow(specularLight, specularExponent) * _Gloss * attenuation;
    specularLight *= light;

    //dissolve
    float noiseLum;
    float distance = 0; 
    float4 remap = 0;
    float2 min_max = float2(_MinDistanceDissolve, _MaxDistanceDissolve);
    Unity_Dither_float(1, float4(i.vertex.xy / i.vertex.w, 0, 0), noiseLum);
    Unity_Distance_float4(float4(_WorldSpaceCameraPos, 0), float4(i.wPos, 0), distance);
    Unity_Remap_float4(distance, min_max, float2(0, 1), remap);
    clip(remap - noiseLum);

    return float4(tex * diffuseLight * _SurfaceColor + specularLight * diffuseIBL, 1);
}
