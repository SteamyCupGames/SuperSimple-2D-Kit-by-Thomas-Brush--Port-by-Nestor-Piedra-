extends StaticBody2D

signal door_opened

@onready var collected_sound = $CollectedSound

var key_has_been_picked = false
var in_door_zone = false

func _ready():
	$AnimationPlayer.play("Idle")
	
func _on_area_2d_body_entered(_body: PhysicsBody2D):
	if key_has_been_picked == false:
		key_has_been_picked = true
		GameManager.has_key = true
		$Sprite2D.queue_free()
		$Sprite2D2.queue_free()
		$CollectedSound.playing = true
		
func _process(_delta):
		if in_door_zone:
			if Input.is_action_just_pressed("Interact") and key_has_been_picked:
				GameManager.has_key = false
				emit_signal("door_opened")

func _on_door_area_body_entered(_body: PhysicsBody2D):
	in_door_zone = true

func _on_door_area_body_exited(_body: PhysicsBody2D):
	in_door_zone = false
