extends Node

@export var pipe_scene : PackedScene

var game_running: bool
var game_over: bool

var scroll
var score

const SCROLL_SPEED : int = 1

var screen_size: Vector2i
var ground_height: int

var pipes: Array
const PIPE_DELAY : int = 500
const PIPE_RANGE : int = 76

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	$ScoreLabel.text = "Score: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	generate_pipes()
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
	game_running = true
	$Player.flying = true
	$Player.flap()
	$PipeTimer.start()

func _process(delta):
	if game_running:
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func check_top():
	if $Player.position.y < 0:
		$Player.falling = true
		stop_game()

func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	
	pipe.position.x = PIPE_DELAY
	pipe.position.y = ground_height / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Player.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$Player.falling = true
	stop_game()

func _on_ground_hit():
	$Player.falling = false
	stop_game()

func _on_game_over_restart():
	new_game()
