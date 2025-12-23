shader_type canvas_item;

uniform sampler2D noise_texture;

uniform float flicker_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flicker_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float vignette_power : hint_range(0.1, 10.0) = 2.5;

void fragment() {
    // Vignette mask
    vec2 c = UV * 2.0 - 1.0;
    float dist = length(c);
    float mask_value = clamp(dist, 0.0, 1.0);
    mask_value = pow(mask_value, vignette_power);

    // Sample noise texture across the screen
    float noise = texture(noise_texture, UV).r;

    // Combine vignette and noise with flicker intensity
    float final_alpha = mask_value * flicker_intensity * noise;

    COLOR = vec4(flicker_color.rgb, final_alpha);
}
