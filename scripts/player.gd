extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

#setting the player's movement speed and jump velocity

const SPEED = 300.0
const JUMP_VELOCITY = -850.0

# controlling whether the player is alive or not
var alive = true

# controlls if the player can move the sprite
var can_move = true

#physics function - created by godot

func _physics_process(delta: float) -> void:
	
	# if the player is dead, don't run the function
	if !alive:
		return
	
	#adding animation for player sprite
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
		
	#adding the gravity
	if not is_on_floor():
		velocity += get_gravity()*delta
	
	# if the player can move
	if can_move: 
		#handling jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.animation = "jumping"
			jump_sound.play()
			
		#get the input direction and handle the movement/deceleration
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		move_and_slide()
		
		#checking what direction the player is moving
		
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		elif direction == -1.0:
			animated_sprite_2d.flip_h = true

# handling the player's death
func die() -> void:
	death_sound.play()
	animated_sprite_2d.animation = "dying"
	alive = false
