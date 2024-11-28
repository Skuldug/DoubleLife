shader_type canvas_item;

// Uniform to control fade factor (0 = transparent, 1 = black)
uniform float fade_factor : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Fade to black based on the fade factor
    COLOR = vec4(0.0, 0.0, 0.0, fade_factor);
}
