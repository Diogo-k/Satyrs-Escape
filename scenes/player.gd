extends CharacterBody2D

const START_POS = Vector2(50, 155)

const GRAVITY : int = 400
const MAX_VEL : int = 300
const FLAP_SPEED: int = -200

var flying : bool = false
var falling : bool = false

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("falling")
		elif falling:
			$AnimatedSprite2D.play("death")
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.play("idle")

func flap():
	$AnimatedSprite2D.play("jump")
	velocity.y = FLAP_SPEED
