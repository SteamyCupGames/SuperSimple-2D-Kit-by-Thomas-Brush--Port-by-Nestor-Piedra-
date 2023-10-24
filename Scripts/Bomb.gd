extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var explode = $Explode
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	if not is_on_floor():
		position.y += gravity * delta

func _on_timer_timeout():
	explode.disabled = false
	await get_tree().create_timer(0.5).timeout
	explode.disabled = true
