extends Area2D

@export var amplitude: float = 50.0  # Maximum height of the up and down movement
@export var frequency: float = 1.0   # Speed of the oscillation

var initial_y: float
var time_passed: float = 0.0

signal hit
signal scored

func _ready():
	initial_y = position.y

func _process(delta):
	time_passed += delta
	position.y = initial_y + amplitude * sin(time_passed * frequency)

func _on_body_entered(body):
	hit.emit()

func _on_score_area_body_entered(body):
	scored.emit()
