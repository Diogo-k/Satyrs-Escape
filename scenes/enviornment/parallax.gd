extends ParallaxBackground

@export var camera_velocity: Vector2 = Vector2(100, 0);

func _process(delta: float) -> void:
	if get_parent().game_running:
		var new_offset: Vector2 = get_scroll_offset() + -camera_velocity * delta
		set_scroll_offset(new_offset)
