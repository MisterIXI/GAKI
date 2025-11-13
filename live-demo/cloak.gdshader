shader_type spatial;

uniform float pulse_speed : hint_range(0.1, 10.0) = 1.0;
uniform float pulse_amplitude : hint_range(0.01, 1.0) = 0.5;
uniform float scroll_speed : hint_range(0.1, 10.0) = 1.0;

void fragment() {
    // Offset the pulse factor by VERTEX.x position for a wave-like effect
    float offset_pulse = sin(TIME * pulse_speed + VERTEX.x * scroll_speed) * 0.5 + 0.5;
    // Apply the offset pulse factor to the alpha
    ALPHA = offset_pulse * pulse_amplitude;
    ALBEDO = vec3(0.0, 0.5, 1.0); // Blue color
}