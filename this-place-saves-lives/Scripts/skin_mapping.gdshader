shader_type canvas_item;

/**
*	skin to sample the actual appearance from
*/
uniform sampler2D skin;
uniform bool active;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 skin_coord = vec2(COLOR.r, COLOR.g);
	if(COLOR.a != 0.0 && active) {
		vec4 sampled = texture(skin, skin_coord);
		COLOR = vec4(sampled.r, sampled.g, sampled.b, COLOR.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
