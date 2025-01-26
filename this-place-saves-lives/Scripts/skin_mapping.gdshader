shader_type canvas_item;

/**
*	skin to sample the actual appearance from
*/
uniform sampler2D skin;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 skin_coord = vec2(COLOR.r, COLOR.g);
	if(COLOR.a != 0.0) COLOR = texture(skin, skin_coord);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
