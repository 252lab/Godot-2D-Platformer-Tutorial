extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var fade: ColorRect = $HUD/Fade

# setting the player's original score
var score = 0

# setting what level the player is on 
var level = 1

# defining variaable in global scope
var current_level_root = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# setting up the fade effect
	fade.modulate.a = 1.0
	
	# setting up the level
	current_level_root = get_node("LevelRoot")
	
	await _setup_level(current_level_root)
	
	await _load_level(level, true, false)
	
	
# LEVEL MANAGEMENT

func _load_level(level_number, first_load, reset_score) -> void:
	
	#fade out
	if not first_load:
		await _fade(1.0)
		
	# if the player has died, reset the score
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"
	
	if current_level_root:
		current_level_root.queue_free()
	
	# change level
	var level_path = "res://scenes/levels/level%s.tscn" %level_number
	
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	
	_setup_level(current_level_root)
	
	# fade in
	await _fade(0.0)
	

# funtion for setting up the level
# e.g. setting up the signal for the snails to emit
func _setup_level(level_root) -> void:
	
	# connecting the apples
	var apples = level_root.get_node_or_null("Apples")
	
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(_increase_score)

	#connect enemies
	var enemies = level_root.get_node_or_null("Enemies")
	
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
	
	# connecting exit signal
	var exit = level_root.get_node_or_null("Exit")
	
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

# SIGNAL HANDLERS

func _on_player_died(body) -> void:
	body.die()
	print("player died")
	await _load_level(level, false, true)
	
	

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player":
		level += 1
		body.can_move = false
		await _load_level(level, false, false)

# SCORE

func _increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" %score

# FADE

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
