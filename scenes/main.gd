extends Node

@export var tree_scene : PackedScene
@export var tree_move_scene : PackedScene
@export var tree_monster_scene : PackedScene

@onready var ScoreLabel = $Score/MarginContainer/Label

var obstacle_table = WeightedTable.new()

var game_running: bool
var game_over: bool

var scroll
var score

const SCROLL_SPEED : int = 1

var screen_size: Vector2i
var ground_height: int

var obstacles: Array
const PIPE_DELAY : int = 500
const OBSTACLE_RANGE : int = 76

func _ready():
	$Player.spell_casted.connect(_on_player_spell_casted)
	$Player.monster_hit.connect(player_hit)
	
	screen_size = get_window().size
	ground_height = $Ground.get_node("ParallaxBackground/Ground/Sprite2D").texture.get_height()
	new_game()

func new_game():
	obstacle_table.clear()
	obstacle_table.add_item(tree_scene, 15)
	
	game_running = false
	game_over = false
	
	scroll = 0
	
	score = 0
	ScoreLabel.text = "Score: " + str(score)
	$Score.hide()
	
	$StartGame.show()
	$GameOver.hide()
	
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("spells", "queue_free")
	obstacles.clear()
	generate_obstacles()
	
	$Platform.build()
	$Player.reset()

func _input(event):
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
	$Score.show()
	game_running = true
	$Player.flying = true
	$Player.flap()
	$ObstacleTimer.start()
	$Platform.destroy()

func _process(delta):
	if game_running:
		for obstacle in obstacles:
			obstacle.position.x -= SCROLL_SPEED

func check_top():
	if $Player.position.y < 0:
		$Player.falling = true
		stop_game()

func _on_obstacle_timer_timeout():
	generate_obstacles()

func generate_obstacles():
	var obstacle_scene = obstacle_table.pick_item()
	var obstacle = obstacle_scene.instantiate()
	
	obstacle.position.x = PIPE_DELAY
	obstacle.position.y = ground_height / 2 + randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)
	
	obstacle.hit.connect(player_hit)
	obstacle.scored.connect(scored)
	
	add_child(obstacle)
	obstacles.append(obstacle)

func scored():
	score += 5
	if score == 5:
		obstacle_table.add_item(tree_move_scene, 10)
	elif score == 10:
		obstacle_table.add_item(tree_monster_scene, 5)
	elif score == 15:
		obstacle_table.add_item(tree_move_scene, 10)
	elif score == 20:
		obstacle_table.add_item(tree_monster_scene, 5)
	elif score == 30:
		obstacle_table.remove_item(tree_scene)
	ScoreLabel.text = "Score: " + str(score)

func player_hit():
	$Player.falling = true
	stop_game()

func stop_game():
	$ObstacleTimer.stop()
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
