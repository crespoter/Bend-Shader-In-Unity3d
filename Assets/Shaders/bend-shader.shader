Shader "bend-shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Strength("Strength", Float) = 0.001
        _BendOrigin("BendOrigin", Vector) = (0,0,0,0)
        _BendFactor("BendFactor", Float) = 1.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        CGPROGRAM
        #pragma surface surfaceShader Lambert vertex:vertexShader
        uniform sampler2D _MainTex;
        uniform float _Strength;
        uniform float4 _BendOrigin;
        uniform float _BendFactor;
        struct Input {
            float2 uv_MainTex;
        };
        void vertexShader(inout appdata_full v) {
            float4 worldSpace = mul(unity_ObjectToWorld, v.vertex); // Converting from object space to world space
            float distanceFromOrigin = length(worldSpace.xyz - _BendOrigin.xyz);
            distanceFromOrigin = pow(distanceFromOrigin, _BendFactor);
            worldSpace.xyz = worldSpace.xyz + (distanceFromOrigin) * _Strength;
            v.vertex = mul(unity_WorldToObject, worldSpace);
        }
        void surfaceShader(Input IN, inout SurfaceOutput o) {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
}
