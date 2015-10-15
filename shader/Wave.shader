Shader "Custom/Wave" {
	Properties{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Scale("Scale", Range(0.0, 2.0)) = 0.1
		_Wave("Wave", Range(1, 50)) = 10
		_Speed("Speed", Range(1.0, 100.0)) = 20.0
		_Pos("pos", Range(0.0, 1.0)) = 20.0
	}
		
		SubShader{
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			Pass{
				Lighting Off
				//Blend SrcAlpha One
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#define PI 3.14159

				#include "UnityCG.cginc"

				uniform float4 _Color;
				uniform float _Scale;
				uniform sampler2D _MainTex;
				uniform float _Wave;
				uniform float _Speed;
				uniform float _pos;

				struct v2f {
					float4 position : SV_POSITION;
					fixed4 color : COLOR;
					float2 uv       : TEXCOORD0;
				};

				v2f vert(appdata_full v) {

					float f = sin(PI * _Time.x * 1000 / _Speed) * _Scale;

					if (v.texcoord.y > _pos) {
						v.vertex.z += sin(v.texcoord.x *  _Wave) * f;
					}

					v2f o;
					o.position = mul(UNITY_MATRIX_MVP, v.vertex);
					o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
					o.color = v.color;
					return o;
				}

				fixed4 frag(v2f i) : COLOR{
					fixed4 tex = tex2D(_MainTex, i.uv);
					tex.rgb *= i.color.rgb;
					tex.a *= i.color.a * _Color.a;

					return tex;
				}
				
				ENDCG
			}
		}
}

