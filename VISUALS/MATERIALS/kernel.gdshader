shader_type spatial;
render_mode unshaded;


uniform vec3 fresnel_color = vec3(0.0, 0.7, 0.9);
uniform vec3 base_color = vec3(0.0, 0.7, 0.9);
uniform float fresnel_amount : hint_range(0.0, 10.0, 0.1);
uniform float glow_intensity  : hint_range(0.0, 10.0, 0.1);
uniform float base_alpha = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}


float fresnel(float amount, float intensity, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * intensity;
}

void fragment()
{
	float  fresnel = fresnel(fresnel_amount, glow_intensity,  NORMAL, VIEW) ;
	ALBEDO = mix(base_color, fresnel* fresnel_color,fresnel) ;
	ALPHA = fresnel + base_alpha;
}
