shader_type canvas_item;

uniform float radius :hint_range(0, 1) = 0.05;
uniform vec4 circle_color : source_color = vec4(1);

void fragment(){
	vec2 pixelNumber = vec2(textureSize(TEXTURE, 0));
	vec2 pixelated_UV = round(UV * pixelNumber) / pixelNumber;
	vec2 uv = (pixelated_UV * 2.0 - 1.0);


	float circle = ceil(length(uv) - radius);
	circle = 1. - circle;
	circle = clamp(circle, 0, circle_color.a);

	COLOR = circle_color;
	COLOR.a = circle;
}


