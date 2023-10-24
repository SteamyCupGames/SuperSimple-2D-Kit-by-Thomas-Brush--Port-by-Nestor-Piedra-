extends Node2D

@onready var area_2d = $Area2D
@onready var icon_e = $IconE
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Stand")
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		icon_e.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		icon_e.visible = false
