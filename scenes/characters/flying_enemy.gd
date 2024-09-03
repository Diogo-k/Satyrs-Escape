class_name FlyingEnemy extends CharacterBody2D

signal hit
signal scored

signal enemy_died

var dead = false

func _process(delta):
	if get_parent().game_running and not dead:
		position.x += 0.75

func _on_body_entered(_body):
	hit.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func die():
	scored.emit()
	collision_layer = 0
	collision_mask = 0
	dead = true
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
