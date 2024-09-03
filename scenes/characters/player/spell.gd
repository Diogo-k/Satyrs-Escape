extends Area2D

@export var speed = 100
var inverted = false

func _physics_process(delta):
	global_position.x -= -speed * delta
	#if inverted:
		#global_position.x += -(speed * 2) * delta
		#$AnimatedSprite2D.flip_h = true
	#else:
		#global_position.x -= -speed * delta
		#$AnimatedSprite2D.flip_h = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area and area.get_parent() is Enemy or area and area.get_parent() is FlyingEnemy:
		area.get_parent().die()
		queue_free()
	elif area.is_in_group("obstacles"):
		queue_free()
