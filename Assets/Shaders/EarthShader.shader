Shader "Custom/DayNight" {
    Properties {
        _DayTex ("Day Texture", 2D) = "white" {}
        _NightTex ("Night Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD4;
                float3 viewDir : TEXCOORD5;
            };

            sampler2D _DayTex;
            sampler2D _NightTex;
            sampler2D _NormalMap;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos - o.worldPos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed3 worldNormal = normalize(tex2D(_NormalMap, i.uv).rgb * 2 - 1);
                worldNormal = worldNormal.x * i.worldTangent + worldNormal.y * i.worldBinormal + worldNormal.z * i.worldNormal;

                fixed4 dayColor = tex2D(_DayTex, i.uv);
                fixed4 nightColor = tex2D(_NightTex, i.uv);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos * +_WorldSpaceLightPos0.w);
                float dotProduct = dot(worldNormal, lightDir);
                float blendFactor = saturate(dotProduct);
                return lerp(nightColor, dayColor, blendFactor);
            }
            ENDCG
        }
    }
}