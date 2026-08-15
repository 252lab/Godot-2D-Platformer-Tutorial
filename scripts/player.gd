extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

#setting the player's movement speed and jump velocity

const SPEED = 300.0
const JUMP_VELOCITY = -850.0

#physics function - created by godot

func _physics_process(delta: float) -> void:
	
	#adding animation for player sprite
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
		
	#adding the gravity
	if not is_on_floor():
		velocity += get_gravity()*delta
		
	#handling jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.animation = "jumping"
		jump_sound 
		
	#get the input direction andhandle the movement/deceleration
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
