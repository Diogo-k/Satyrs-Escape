extends MarginContainer

@onready var label = $Label
@export var text_to_display: String = "Help! Demons are after me!"  # The text to display
@export var typing_speed: float = 0.075  # Time between each character (in seconds)

func _ready():
	reveal_text()

func reveal_text():
	label.text = ""
	
	for i in range(text_to_display.length()):
		label.text += text_to_display[i]
		await get_tree().create_timer(typing_speed).timeout  # Wait for the next character
