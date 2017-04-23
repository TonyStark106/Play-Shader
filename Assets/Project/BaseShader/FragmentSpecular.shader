// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Play Shader/FragmentSpecular" {

	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(10, 255)) = 10
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
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				fixed3 worldNormal: TEXCOORD0;
				float3 worldPos: TEXCOORD1;
			};

			v2f vert(a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldNormal = UnityObjectToWorldNormal(i.normal);
				o.worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
				return o;
			}

			float4 frag(v2f i): SV_Target {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed NdotL = dot(worldLight, worldNormal);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(NdotL);
				float reflectDir = normalize(reflect(-worldLight, worldNormal));
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);

				float3 half = normalize(viewDir + worldLight);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, half)), _Gloss);

				// fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
				fixed3 color = ambient + diffuse + specular;
				return fixed4(color, 1);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
