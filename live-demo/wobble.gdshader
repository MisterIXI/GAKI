shader_type canvas_item;
uniform float wave_frequency = 10.0;
uniform float wave_speed = 5.0;
uniform float wave_amplitude = 0.01;

void fragment() {
	float wave_x = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude - wave_amplitude;
	float wave_y = sin(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude - wave_amplitude;
	vec2 wave_uv = UV + vec2(wave_x, wave_y);
	COLOR = texture(TEXTURE, wave_uv);
}
