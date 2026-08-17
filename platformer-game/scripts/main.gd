extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel

# setting the player's original score
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# funtion for setting up the level
# e.g. setting up the signal for the snails to emit
func _setup_level() -> void:
	
	# connecting the apples
	var apples = $LevelRoot.get_node_or_null("Apples")
	
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(_increase_score)
	
	#connect enemies
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
	

# SIGNAL HANDLERS

func _on_player_died(body) -> void:
	body.die()
	print("player died")

# SCORE

func _increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" %score
