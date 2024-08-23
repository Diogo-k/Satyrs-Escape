extends Area2D

@onready var parallax_background = $ParallaxBackground

var camera_velocity: Vector2 = Vector2(175, 0);

signal hit

func _process(delta: float):
	if get_parent().game_running:
		var new_offset: Vector2 = parallax_background.get_scroll_offset() + -camera_velocity * delta
		parallax_background.set_scroll_offset(new_offset)

func _on_body_entered(body):
	hit.emit()
