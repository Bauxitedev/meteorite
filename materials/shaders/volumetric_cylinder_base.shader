shader_type spatial;
render_mode blend_add, cull_disabled, unshaded;

uniform vec4 col : hint_color;
//default is  = vec3(0.5,0.8,0.4) 

varying vec3 pos;

void vertex()
{
	pos = VERTEX;
}

void fragment()
{
	ALBEDO = pow(vec3(max(0.0,-pos.y)), vec3(3.0)) * col.rgb;
}