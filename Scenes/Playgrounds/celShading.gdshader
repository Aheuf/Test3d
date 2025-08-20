shader_type spatial;
render_mode depth_draw_opaque, cull_back, diffuse_toon, specular_toon;

uniform vec4 albedo: source_color;
uniform sampler2D color_gradient;
uniform sampler2D fresnel_gradient;


// seuils d’intensité pour les 3 zones
uniform float threshold1 = 0.05;
uniform float threshold2 = 0.5;

float fresnel(float amount, vec3 normal, vec3 view) { 
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0, 1)), amount);
} 

void vertex() {
	 // Called for every vertex the material is visible on. 
}

void fragment() {
	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	ALBEDO = albedo.rgb + (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);
}
	
void light() {
	float NdotL = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	float toonStep = 0.0;
	
	if (NdotL < threshold1) {
	// Ombre
		toonStep = 0.0;
	} else if (NdotL < threshold2) {
	// Mid 
		toonStep = 0.5; 
	} else {
	// Lumière 
		toonStep = 1.0;
	} 
	vec3 toonColor = vec3(toonStep);
	// noir/gris/blanc 
	DIFFUSE_LIGHT += toonColor * LIGHT_COLOR * ATTENUATION;
}