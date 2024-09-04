extends Node

@export var tree_scene : PackedScene
@export var tree_move_scene : PackedScene
@export var tree_enemy_scene : PackedScene

@onready var HighLabel = $Record/MarginContainer/VBoxContainer/High
@onready var LastLabel = $Record/MarginContainer/VBoxContainer/Last

@onready var ScoreLabel = $Score/MarginContainer/Label

const MAIN_THEME = preload("res://assets/audio/main_theme.wav")
const MAIN_THEME_ACTION = preload("res://assets/audio/main_theme_action.wav")

var obstacle_table = WeightedTable.new()

var game_running: bool
var game_over: bool
var is_muted = false

var screen_size: Vector2i
var ground_height: int

const OBSTACLE_DELAY : int = 600
const OBSTACLE_RANGE : int = 76
const MOVING_OBSTACLE_RANGE : int = 10

var score

func _ready():
	$Player.spell_casted.connect(_on_player_spell_casted)
	$Player.monster_hit.connect(player_hit)
	
	screen_size = get_window().size
	ground_height = $Ground.get_node("ParallaxBackground/Ground/Sprite2D").texture.get_height()
	new_game()

func new_game():
	MusicPlayer.stream = MAIN_THEME
	MusicPlayer.play()
	$GameOver.hide()
	
	obstacle_table.clear()
	obstacle_table.add_item(tree_scene, 15)
	
	game_running = false
	game_over = false
	
	score = 0
	
	HighLabel.text = "Highest Score: " + str(Save.save_data["high_score"])
	LastLabel.text = "Previous Score: " + str(Save.save_data["last_score"])
	ScoreLabel.text = "Score: " + str(score)
	
	$Score.hide()
	
	if Save.save_data and int(Save.save_data["high_score"]) > 0:
		$Record.show()
	
	$StartGame.show()
	
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("spells", "queue_free")
	get_tree().call_group("enemies", "queue_free")
	
	$Platform.build()
	$Player.reset()

func _input(event):
	if Input.is_action_just_pressed("mute"):
		toggle_mute()
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Player.flying:
						$Player.flap()
						check_top()

func start_game():
	$StartGame.hide()
	$Record.hide()
	$Dialog.hide()
	$Platform.destroy()
	
	game_running = true
	
	$Player.flap()
	$Player.flying = true
	$Score.show()
	
	$ObstacleTimer.start()

func check_top():
	if $Player.position.y < 0:
		$Player.falling = true
		stop_game()

func _on_obstacle_timer_timeout():
	generate_obstacles()

func generate_obstacles():
	var obstacle_scene = obstacle_table.pick_item()
	var obstacle = obstacle_scene.instantiate()
	
	obstacle.position.x = OBSTACLE_DELAY
	if obstacle.moving_tree:
		obstacle.position.y = ground_height / 2.0 + randi_range(-MOVING_OBSTACLE_RANGE, MOVING_OBSTACLE_RANGE)
	else:
		obstacle.position.y = ground_height / 2.0 + randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)
	
	obstacle.hit.connect(player_hit)
	obstacle.scored.connect(scored)
	
	add_child(obstacle)

func scored():
	score += 1
	ScoreLabel.text = "Score: " + str(score)
	
	if score == 5:
		obstacle_table.add_item(tree_move_scene, 10)
	elif score == 10:
		obstacle_table.add_item(tree_enemy_scene, 5)
	elif score == 15:
		obstacle_table.add_item(tree_move_scene, 10)
	elif score == 20:
		obstacle_table.add_item(tree_enemy_scene, 5)
		MusicPlayer.play_song(MAIN_THEME_ACTION)
	elif score == 30:
		obstacle_table.add_item(tree_enemy_scene, 5)
		obstacle_table.remove_item(tree_scene)

func player_hit():
	$Player.falling = true
	stop_game()

func stop_game():
	if game_running and not game_over:
		MusicPlayer.stop()
		
		Save.update_score(score)
		
		$ObstacleTimer.stop()
		
		$GameOverSound.play()
		
		$GameOver.show()
		
		$Player.flying = false
		
		game_running = false
		game_over = true

func _on_ground_hit():
	$Player.falling = false
	stop_game()

func _on_game_over_restart():
	new_game()

func _on_player_spell_casted(spell_scene, location):
	var spell = spell_scene.instantiate()
	spell.global_position = location
	add_child(spell)

func toggle_mute():
	is_muted = !is_muted
	var volume = -80 if is_muted else 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
