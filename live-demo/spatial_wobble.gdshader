shader_type spatial;

uniform float wobble_speed : hint_range(0.1, 10.0) = 1.0;
uniform float wobble_amplitude : hint_range(0.01, 0.5) = 0.1;

void vertex() {
    // Calculate the distance from the center of the sphere
    float distance_from_center = length(VERTEX);

    // Calculate the wobble factor using a sine function
    float wobble_factor = sin(TIME * wobble_speed + VERTEX.x * 5.0) * wobble_amplitude;

    // Apply the wobble factor to the vertex position
    VERTEX.y += wobble_factor * distance_from_center;
    VERTEX.z += wobble_factor * distance_from_center;
}

void fragment() {
    // Simple fragment shader to render the sphere
    ALBEDO = vec3(0.0, 0.5, 1.0); // Blue color
}