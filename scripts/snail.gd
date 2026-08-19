extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#signal to indicate that the player is dead
signal player_died

#movement speed of the snail
const SPEED = 100.0

#starting direction of the snail
#negative as the snail is facing left
var direction = -1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#updating the position of the snail
	position.x += direction * SPEED * delta

func _on_timer_timeout() -> void:
	# flip the direction of movement
	direction *= -1.
	
	#updating the animation
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

#handling if the player collides with a snail
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and body.alive:
		emit_signal("player_died", body)
		
	
