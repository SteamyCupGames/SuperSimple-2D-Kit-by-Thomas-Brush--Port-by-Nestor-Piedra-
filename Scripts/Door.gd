extends StaticBody2D

@onready var icon_e = $IconE
@onready var animation_player = $AnimationPlayer
@onready var open_sound = $OpenSound

var open = false

func _physics_process(_delta):
	if open:
		animation_player.play("Open")
		open = false
		open_sound.play()
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		icon_e.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		icon_e.visible = false

func _on_key_door_opened():
	open = true
