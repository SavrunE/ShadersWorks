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

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

sampler2D _MainTex;
float4 _MainTex_TexelSize;

sampler2D _ColorRampTex;

half _DissolveValue;

static float3 _grayScale = float3(0.299, 0.587, 0.114);

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

fixed4 frag(v2f i) : SV_Target
{
    float3 tex = tex2D(_MainTex, i.uv);
    // fixed3 mainCol = tex2D(_MainTex, i.uv).rgb;
    // float mainLum = dot(mainCol, _grayScale);

    float noiseLum;
    Unity_Dither_float(1, float4(i.vertex.xy / i.vertex.w, 0, 0), noiseLum);
    clip(noiseLum < _DissolveValue ? -1 : 1);

    // float rampVal = mainLum < noiseLum ? noiseLum - mainLum : 0.99;
    // returnCol += tex2D(_ColorRampTex, float2(noiseLum, noiseLum));
    return float4(tex, noiseLum);
}
