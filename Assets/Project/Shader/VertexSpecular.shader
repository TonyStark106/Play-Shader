Shader "Play Shader/VertexSpecular" {

	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(1, 255)) = 10
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
				fixed3 color: COLOR;
			};

			v2f vert(a2v i) {
				v2f o;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				o.pos = UnityObjectToClipPos(i.vertex);
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = normalize(UnityObjectToWorldNormal(i.normal));
				fixed NdotL = dot(worldLight, worldNormal);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(NdotL);
				float reflectDir = normalize(reflect(-worldLight, worldNormal));
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz);
				fixed3 specular = _LightColor0 * _Specular * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
				o.color = ambient + diffuse + specular;
				return o;
			}

			float4 frag(v2f i): SV_Target {
				return fixed4(i.color, 1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
