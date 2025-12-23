shader_type canvas_item;

uniform float flow_speed = 0.6;
uniform float noise_scale = 3.0;
uniform float intensity = 1.2;

uniform vec4 color_a : source_color = vec4(0.2, 0.8, 1.0, 1.0);
uniform vec4 color_b : source_color = vec4(0.8, 0.3, 1.0, 1.0);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x) +
		(c - a) * u.y * (1.0 - u.x) +
		(d - b) * u.x * u.y;
}

void fragment() {
	vec2 uv = UV * noise_scale;

	float t = TIME * flow_speed;

	float n = noise(uv + vec2(t, -t));
	float n2 = noise(uv * 1.7 - vec2(t * 0.5, t));

	float flow = smoothstep(0.2, 0.8, n + n2 * 0.5);

	vec4 energy_color = mix(color_a, color_b, flow);
	energy_color.rgb *= intensity;

	COLOR = energy_color;
}
