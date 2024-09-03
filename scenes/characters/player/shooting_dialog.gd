extends MarginContainer

@onready var label = $Label
@export var text_to_display: String = "They Keep Chasing Me! Press Space to KILL THEM!" # The text to display
@export var typing_speed: float = 0.075  # Time between each character (in seconds)

func _ready():
	reveal_text()

func _physics_process(delta):
	if Input.is_action_pressed("attack"):
		queue_free()

func reveal_text():
	label.text = ""
	for i in range(text_to_display.length()):
		label.text += text_to_display[i]
		await get_tree().create_timer(typing_speed).timeout  # Wait for the next character
