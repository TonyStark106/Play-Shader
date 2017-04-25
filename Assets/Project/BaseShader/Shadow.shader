Shader "Play Shader/Shadow" {
	Properties {
		_DiffuseColor("Diffuse Color", Color) = (1, 1, 1, 1)

	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ShadowCaster" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			float4 _DiffuseColor;

			v2f vert(appdata_base v) {
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			fixed4 frag(v2f i): SV_TARGET {
				SHADOW_CASTER_FRAGMENT(i);
			} 

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct a2v {
				float4 vertex: POSITION;
				fixed3 normal: NORMAL;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				fixed3 color: TEXCOORD0;
				SHADOW_COORDS(1)
			};

			float4 _DiffuseColor;

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				fixed3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				fixed3 worldLight = normalize(WorldSpaceLightDir(v.vertex));
				fixed NdotL = max(0, dot(worldLight, worldNormal));
				o.color = _LightColor0.rgb * _DiffuseColor.rgb * NdotL;

				TRANSFER_SHADOW(o);

				return o;
			}

			fixed4 frag(v2f i): SV_TARGET {
				fixed shadow = SHADOW_ATTENUATION(i);
				return fixed4(i.color * shadow, 1);

			} 


			ENDCG

		}


	}

}