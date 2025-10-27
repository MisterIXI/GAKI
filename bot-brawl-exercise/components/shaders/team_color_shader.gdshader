shader_type canvas_item;

const float max_red_value = 190.0 / 255.0;
uniform vec4 target_color : source_color = vec4(0.7, 0.0, 0.0, 1.0);

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	// check if pixel is primarily red coloured
	if(current_pixel.r > (current_pixel.b + current_pixel.g) * 0.5)
	{
		// divide by 190 (converted from 255 to 1.0 value), ca highest red value of the original images
		float mult = current_pixel.r / max_red_value;
		// check how close the colors are to approximate blending between colors
		float diff_g = current_pixel.g / current_pixel.r;
		// get min value of current color to adjust blending target
		float avg_val = (current_pixel.r + current_pixel.g + current_pixel.b) / 3.0;
		// adapt target color to actual pixel color
		current_pixel.rgb = target_color.rgb * mult + (vec3(avg_val) - target_color.rgb * mult) * diff_g;
	}
	COLOR = current_pixel;
}
