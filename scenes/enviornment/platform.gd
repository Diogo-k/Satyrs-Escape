extends Node2D

@onready var sprite_2d = $Sprite2D

func build():
	var sprite_material = sprite_2d.material
	sprite_material.set_shader_parameter("sensitivity", 0.0)
	
	var tween = create_tween()
	tween.tween_property(sprite_material, "shader_parameter/sensitivity", 0.0, 0.10).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

func destroy():
	var sprite_material = sprite_2d.material
	sprite_material.set_shader_parameter("sensitivity", 0.0)
	
	var tween = create_tween()
	tween.tween_property(sprite_material, "shader_parameter/sensitivity", 1.0, 0.10).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
