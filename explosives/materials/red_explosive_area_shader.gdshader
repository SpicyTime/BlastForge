shader_type canvas_item;
uniform float radius :hint_range(0, 1) = 0.05;
uniform vec4 circle_color : source_color = vec4(1.0, 0.0, 0.0, 0.5);
uniform float speed = 9.0;
uniform float phase_offset = 0.0;
void fragment(){
	// Texture size in pixels
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));

    // Convert UVs to pixel coordinates
    vec2 pixel_uv = UV * tex_size;
	
	pixel_uv = floor(pixel_uv) + 0.5;
    // Center of the quad in pixels
    vec2 center = tex_size * 0.5;

    // Distance from center in pixels
    float dist = distance(pixel_uv, center);

    // Hard circle mask (0 or 1)
    float circle = step(dist, radius);

	float pulse = (sin((TIME + phase_offset) * speed) * 0.5) + 1.25;
    COLOR = circle_color;
    COLOR.a *= circle * pulse;
}
