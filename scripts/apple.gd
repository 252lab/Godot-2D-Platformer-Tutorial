extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# signal for notifying when an apple has been collected
signal collected

# when the player interacts with the appls, the player collects it
func _on_body_entered(_body: Node2D) -> void:
	animated_sprite_2d.animation = "collected"
	collected_sound.play()
	collected.emit()
	call_deferred("_disable_collision")

# apple is then removed from the level, so it cannot be infinitely collected
func _disable_collision() -> void:
	collision_shape_2d.disabled = true

#checking if the collected animation has finished
# and therefore the object can be deleted
func _on_animated_sprite_2d_animation_looped() -> void:
	
	if animated_sprite_2d.animation == "collected":
		queue_free()
