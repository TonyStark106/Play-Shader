Shader "Play Shader/Tex2D" {

	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_MainTex("_MainTex", 2D) = "white" {}
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
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct a2v {
				float4 vertex: POSITION;
				float4 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 pos: SV_POSITION;
				fixed2 uv: TEXCOORD0;
			};

			v2f vert(a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);

				// 第一个参数可四位数
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				// o.uv = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			float4 frag(v2f i): SV_Target {
				fixed3 t = tex2D(_MainTex, i.uv).rgb;
				return fixed4(t * _Diffuse.rgb, 1);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
