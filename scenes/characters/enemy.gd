class_name Enemy extends CharacterBody2D

signal enemy_died

func die():
	enemy_died.emit()
	collision_layer = 0
	collision_mask = 0
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
