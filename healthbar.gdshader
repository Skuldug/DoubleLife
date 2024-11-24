//shader_type canvas_item;
//
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
//uniform float transition_factor : hint_range(0.0, 1.0); // Transition factor for grayscale effect
//
//void fragment() {
    //// Check the value of transition_factor and apply the color accordingly
    //if (transition_factor < 0.33) {
        //// Blue when transition_factor is between 0.0 and 0.33
        //COLOR = vec4(0.0, 0.0, 1.0, 1.0);  // Blue color
    //} else if (transition_factor < 0.66) {
        //// Green when transition_factor is between 0.33 and 0.66
        //COLOR = vec4(0.0, 1.0, 0.0, 1.0);  // Green color
    //} else {
        //// Red when transition_factor is greater than 0.66
        //COLOR = vec4(1.0, 0.0, 0.0, 1.0);  // Red color
    //}
//}


shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float transition_factor : hint_range(0.0, 1.0); // Transition factor for grayscale effect

void fragment() {
    // Sample the screen texture
    vec4 color = texture(screen_texture, SCREEN_UV);

    // Convert to grayscale using luminance
    float grey = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Blend between the original color and grayscale based on the transition factor
    COLOR = mix(color, vec4(vec3(grey), color.a), transition_factor);
}

//shader_type canvas_item;
//
//void fragment() {
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Solid red
//}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
