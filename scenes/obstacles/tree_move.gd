extends Area2D

var moving_tree = true

@export var amplitude: float = 50.0  # Maximum height of the up and down movement
@export var frequency: float = 1  # Speed of the oscillation

var phase_offset = 0.0

var initial_y: float
var time_passed: float = 0.0

signal hit
signal scored

func _ready():
	phase_offset = randf() * PI * 2.0
	initial_y = position.y

func _physics_process(delta):
	if get_parent().game_running:
		position.x -= 2.5
		time_passed += delta
		position.y = initial_y + amplitude * sin(time_passed * frequency + phase_offset)

func _on_body_entered(_body):
	hit.emit()

func _on_score_area_body_entered(_body):
	scored.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
