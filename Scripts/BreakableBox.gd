extends Node2D

@export var health = 3
var coin = preload("res://Prefabs/Interactables/Coins.tscn")
var particles = preload("res://Prefabs/Particles/BoxExplosion.tscn")

@onready var level_parent = $"../."
@onready var hit_sound = $HitSound
@onready var break_sound = $BreakSound

func take_damage():
	$AnimationPlayer.play("Hit")
	health -= 1
	hit_sound.playing = true
	if health <= 0:
		$Box.queue_free()
		$CollisionShape2D.queue_free()
		var instanced_particles = instantiate_particles()
		instanced_particles.emitting = true
		break_sound.playing = true
		for i in range(3, 0, -1):
			var instanced_coin = instantiate_coin()
			instanced_coin.spawn()

func instantiate_coin():
	var instance = coin.instantiate()
	add_child(instance)
	instance.position.x += randi() % 10 + 1
	instance.position.y -= randi() % 100 + 1
	return instance

func instantiate_particles():
	var instance = particles.instantiate()
	add_child(instance)
	instance.position = get_parent().position
	return instance
