extends CharacterBody2D

var player
var health = 30
var speed: float = 1.0

@onready var target = $"."
@onready var timer = $Timer
@onready var enemy_explode = $EnemyExplode
@onready var hitbox = $Hitbox
@onready var area_2d = $Area2D
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var bomb = preload("res://Prefabs/Characters/Bomb.tscn")
var coin = preload("res://Prefabs/Interactables/Coins.tscn")
var particles = preload("res://Prefabs/Particles/EnemyExplosion.tscn")
var is_alive = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body

func _process(delta):
	if player and is_alive:
		var target_x = player.position.x
		position.x = lerp(position.x, target_x, speed * delta)
		position.y = lerp(position.y, player.position.y - 300 , speed * delta)
		
func _on_hitbox_body_entered(body):
	if body.name == "Player":
		GameManager.health -= 10
		GameManager.is_damage = true
		GameManager.play_hurtheal_animation = true

func take_damage():
	health -= 10
	$AnimationPlayer.play("Hit")
	if health <= 0:
		is_alive = false
		enemy_explode.playing = true
		sprite_2d.queue_free()
		hitbox.queue_free()
		for i in range(5, 0, -1):
			var instanced_coin = instantiate_coin()
			instanced_coin.spawn()
		collision_shape_2d.queue_free()
		var instanced_particles = instantiate_particles()
		instanced_particles.emitting = true

#func _on_timer_timeout():
#	if is_alive:
#		var instance = bomb.instantiate()
#		add_child(instance)

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
