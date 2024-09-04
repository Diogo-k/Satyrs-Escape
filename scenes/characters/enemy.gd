class_name Enemy extends CharacterBody2D

signal enemy_died

func die():
	collision_layer = 0
	collision_mask = 0
	$Hurtbox.collision_layer = 0
	$Hurtbox.collision_mask = 0
	
	enemy_died.emit()
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
