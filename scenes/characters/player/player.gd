extends CharacterBody2D

const START_POS = Vector2(240, 165)

const GRAVITY : int = 400
const MAX_VEL : int = 300
const FLAP_SPEED: int = -200

var flying : bool = false
var falling : bool = false

var spell_scene = preload("res://scenes/characters/player/spell.tscn")
signal spell_casted(spell_scene, location)

@export var rate_of_fire: float = 0.50
var spell_cd: bool = false

signal monster_hit # DEATH BY MONSTER

func _ready():
	reset()

func reset():
	$PointLight2D.enabled = true
	falling = false
	flying = false
	position = START_POS
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if Input.is_action_pressed("attack") and get_parent().game_running:
		if !spell_cd:
			spell_cd = true
			attack()
			await get_tree().create_timer(rate_of_fire).timeout
			spell_cd = false
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("falling")
		elif falling:
			$PointLight2D.enabled = false
			$AnimatedSprite2D.play("death")
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.play("idle")

func flap():
	$JumpPlayer.play()
	$AnimatedSprite2D.play("jump")
	velocity.y = FLAP_SPEED

func attack():
	$SpellPlayer.play()
	$AnimatedSprite2D.play("attack")
	spell_casted.emit(spell_scene, $Marker2D.global_position)

func _on_hurtbox_body_entered(_body):
	$PointLight2D.enabled = false
	$AnimatedSprite2D.play("death")
	monster_hit.emit()
