shader_type canvas_item;

/**
*	skin to sample the actual appearance from
*/
uniform sampler2D skin;

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR.a != 0.0) {
		vec2 skin_uv = (COLOR.gr*256.0)/23.0;
		vec4 sampled = texture(skin, skin_uv);
		COLOR = vec4(sampled.r, sampled.g, sampled.b, sampled.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
