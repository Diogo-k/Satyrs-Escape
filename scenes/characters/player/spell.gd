extends Area2D

@export var speed = 100

func _physics_process(delta):
	global_position.x -= -speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	print(area)
	if area and area.get_parent() is Enemy:
		area.get_parent().die()
		queue_free()
	elif area.is_in_group("obstacles"):
		queue_free()
