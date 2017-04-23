Shader "Play Shader/AlphaTest" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_AlphaTex("Aplha Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Cutoff("Cutoff", Range(0, 1)) = 1
	}

	SubShader {

		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }


		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			fixed _Cutoff;
			float4 _Color;

			struct a2v {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float4 texcoord: TEXCOORD;
			};
			struct v2f {
				float4 pos: SV_POSITION;
				float3 worldNormal: TEXCOORD0;
				float4 worldPos: TEXCOORD1;
				float2 uv: TEXCOORD2;
			};

			v2f vert(a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldPos = mul(UNITY_MATRIX_M, i.vertex);
				o.worldNormal = UnityObjectToWorldNormal(i.normal);
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i): SV_TARGET {
				float4 texColor = tex2D(_MainTex, i.uv);
				fixed alpha = tex2D(_AlphaTex, i.uv).r;
				clip(alpha - _Cutoff);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed NdotL = max(0, dot(worldLight, worldNormal));
				fixed3 albedo = texColor.rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
				fixed3 diffuse = albedo * NdotL * _LightColor0;
				fixed3 color =  diffuse + ambient;
				return fixed4(color, alpha);
			}


			ENDCG
		}

		Pass {
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			fixed _Cutoff;
			float4 _Color;

			struct a2v {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float4 texcoord: TEXCOORD;
			};
			struct v2f {
				float4 pos: SV_POSITION;
				float3 worldNormal: TEXCOORD0;
				float4 worldPos: TEXCOORD1;
				float2 uv: TEXCOORD2;
			};

			v2f vert(a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldPos = mul(UNITY_MATRIX_M, i.vertex);
				o.worldNormal = UnityObjectToWorldNormal(-i.normal);
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i): SV_TARGET {
				float4 texColor = tex2D(_MainTex, i.uv);
				fixed alpha = tex2D(_AlphaTex, i.uv).r;
				clip(alpha - _Cutoff);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed NdotL = max(0, dot(worldLight, worldNormal));
				fixed3 albedo = texColor.rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
				fixed3 diffuse = albedo * NdotL * _LightColor0;
				fixed3 color =  diffuse + ambient;
				return fixed4(color, alpha);
			}


			ENDCG
		}

	}

	FallBack "Diffuse"
}