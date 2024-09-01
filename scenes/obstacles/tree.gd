extends Area2D

signal hit
signal scored

func _process(delta):
	if get_parent().game_running:
		position.x -= 1

func _on_body_entered(_body):
	hit.emit()

func _on_score_area_body_entered(_body):
	scored.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
