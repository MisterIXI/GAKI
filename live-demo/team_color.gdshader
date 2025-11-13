shader_type canvas_item;

const float max_red_value = 190.0 / 255.0;
uniform vec4 target_color : source_color = vec4(0.7, 0.0, 0.0, 1.0);

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if(current_pixel.r > (current_pixel.b + current_pixel.g) * 0.5)
	{
		current_pixel = target_color;
	}
	COLOR = current_pixel;
}
