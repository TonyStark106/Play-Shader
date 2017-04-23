Shader "Play Shader/ForwardSepular" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" { }
		_NormalMap("Normal Map", 2D) = "Bump" { }
		_SepularTex("Sepular Texture", 2D) = "white" { }
		_SepularColor("Sepular Color", Color) = (1, 1, 1, 1)
		_Shininess("Shininess", Range(0, 1)) = 0
		_Gloss("Gloss", Range(10, 255)) = 10
		_Emission("Emission Texture", 2D) = "black" { }
		_EmissionColor("Emission Color", Color) = (0, 0, 0, 0)
	}

	SubShader {
		Tags { }
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			sampler2D _SepularTex;
			float4 _SepularTex_ST;
			fixed4 _SepularColor;
			fixed _Shininess;
			float _Gloss;
			sampler2D _Emission;
			float4 _EmissionColor;

			struct a2v {
				float4 vertex: POSITION;
				fixed3 normal: NORMAL;
				
			};

			struct v2f {
				float4 pos: SV_POSITION;
				fixed3 worldNormal: TEXCOORD0;
			};

			v2f vert(a2v i) {


			}

			fixed4 frag(v2f i): SV_TARGET {


			}


			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			CGPROGRAM
			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Normal;
			float4 _Normal_ST;
			fixed4 _SepularColor;

			ENDCG
		}
	}

	FallBack "Sepular"
}
