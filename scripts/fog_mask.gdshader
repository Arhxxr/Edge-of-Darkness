shader_type canvas_item;
render_mode blend_mix;

// Grabs texture from Sprite2D. White = transparent.
// Fog texture.
uniform sampler2D noise;

// Ammount of detail.
uniform int octaves = 4;

// Opacity of the output fog.
uniform float starting_amplitude: hint_range(0.0, 1) = 0.5;

// Rate of pattern within the fog.
uniform float starting_frequency = 1.0;

// Shift towards transparency (clamped) for sparser fog.
uniform float shift: hint_range(-1.0, 0.0) = -0.02;

// Shift towards transparency (clamped) for sparser fog.
uniform float alpha_cutoff: hint_range(0.0, 1.0) = 0.7;

// Direction and speed of travel.
uniform vec2 velocity = vec2(1.0, 1.0);

// Color of the fog.
uniform vec4 fog_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fog_color2: source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform vec4 light_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);



float rand(vec2 uv) {
	float amplitude = starting_amplitude;
	float frequency = starting_frequency;
	float output = 0.0;
	for (int i = 0; i < octaves; i++) {
		output += texture(noise, uv * frequency).x * amplitude;
		amplitude /= 2.0;
		frequency *= 2.0;
	}
	
	return clamp(output + shift, 0.0, 1.0);
}

void fragment() {
	vec2 motion = vec2(rand(UV + (TIME * starting_frequency * velocity)));
	vec4 mask = texture(TEXTURE, UV);

	vec4 color = mix(fog_color, fog_color2, rand(UV+motion));
	
	if (mask.r == 1.0) {
		color.a = 0.0;
	} else {
		// ALTER MASK IMAGE
		float alpha =  mask.r - rand(UV+motion);
		if (alpha >= alpha_cutoff) {
			alpha = 1.0;
		}
		color.a = 1.0 - alpha;
	}

	COLOR = color;
}
