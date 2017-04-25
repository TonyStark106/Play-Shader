Shader "Play Shader/AlphaBlend" {

	Properties {
		_MainTex("Main Texture", 2D) = "white" { }
		_AlphaTex("Alpht Texture", 2D) = "white" { }
		_Color("Color", Color) = (1, 1, 1, 1)
		_AlphaScale("AlphaScale", Range(0, 1)) = 1 
	}

	SubShader {
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		// Pass {
		// 	ZWrite On
		// 	ColorMask 0
		// }

		Pass {
			Tags { "LightMode" = "ForwardBase" }
			ZWrite Off
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			fixed _AlphaScale;
			fixed4 _Color;

			struct a2v {
				float4 vertex: POSITION;
				fixed3 normal: NORMAL;
				float4 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				float4 worldPos: TEXCOORD0;
				fixed3 worldNormal: TEXCOORD1;
				float2 uv: TEXCOORD2;
			};

			v2f vert(a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldNormal = UnityObjectToWorldNormal(i.normal);
				o.worldPos = mul(unity_ObjectToWorld, i.vertex);
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i): SV_TARGET {
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
				fixed NdotL = max(dot(worldNormal, worldLight), 0);
				fixed4 albedo = tex2D(_MainTex, i.uv) * _Color;
				fixed alpha = tex2D(_AlphaTex, i.uv).r * _AlphaScale;
				fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT * albedo;
				fixed4 diffuse = albedo * _LightColor0 * NdotL;
				fixed4 color = diffuse + ambient;
				return fixed4(color.rbg, alpha);
			}


			ENDCG

		}

	}



}