shader_type canvas_item;

uniform float height = 0;
uniform float frequency = 0;
uniform float speed = 0;

void vertex() {
 VERTEX.y += height * sin(speed * TIME);
}