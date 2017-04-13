Shader "Play Shader/HalfLambert" {

	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)

	}

	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			struct a2v {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				float3 worldNormal: NORMAL;
			};

			v2f vert(a2v i) {
				v2f o;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				o.pos = UnityObjectToClipPos(i.vertex);	
				o.worldNormal = UnityObjectToWorldNormal(i.normal);			
				return o;
			}

			float4 frag(v2f i): SV_Target {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed NdotL = dot(worldLight, worldNormal) * 0.5 + 0.5;
				fixed3 diffuse = _LightColor0 * _Diffuse * NdotL;
				fixed3 color = diffuse + ambient;
				return fixed4(color, 1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
