extends Area2D

@onready var ui_elements = $UIElements
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $UIElements/AnimationPlayer

func _on_body_entered(body):
	if body.name == "Player":
		$CollectedSound.playing = true
		GameManager.gain_coins(1)
		ui_elements.queue_free()
		collision_shape_2d.queue_free()
		
func _ready():
	animation_player.play("Idle")
	
func spawn():
	animation_player.play("Spawn")
