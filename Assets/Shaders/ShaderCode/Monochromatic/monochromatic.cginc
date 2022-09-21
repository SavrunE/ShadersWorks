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

v2f vert (appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

sampler2D _MainTex;
float4 _MainTex_TexelSize;

sampler2D _NoiseTex;
float4 _NoiseTex_TexelSize;

sampler2D _ColorRampTex;

static float3 _grayScale = float3(0.299, 0.587, 0.114);

fixed4 frag (v2f i) : SV_Target
{
    half3 returnCol = 0;
    fixed3 mainCol = tex2D(_MainTex, i.uv).rgb;
    float mainLum = dot(mainCol, _grayScale);

    float2 noiseUV = i.uv * _NoiseTex_TexelSize.xy * _MainTex_TexelSize.zw;
    fixed3 noiseCol = tex2D(_NoiseTex, noiseUV);
    float noiseLum = 1 - dot(noiseCol, _grayScale);
    clip(noiseLum - .15);

    float rampVal = mainLum < noiseLum ? noiseLum - mainLum : 0.99;
    returnCol += tex2D(_ColorRampTex, float2(rampVal, 0.5));
    return float4(returnCol, 1.0);
    
}