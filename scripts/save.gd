extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"high_score": 0,
	"last_score": 0
}

func _ready():
	load_save_file()

func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()

func update_score(new_score: int):
	if save_data["high_score"] == 0:
		save_data["high_score"] = new_score
		save_data["last_score"] = new_score
	elif save_data["high_score"] > 0:
		if new_score > save_data["high_score"]:
			save_data["high_score"] = new_score
		save_data["last_score"] = new_score
	save()
