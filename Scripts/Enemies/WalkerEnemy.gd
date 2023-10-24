extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health = 30
var speed = -500
var is_going_right = false
var knockback_dir
var knockback
var motion = Vector2()

@onready var sprite_2d = $Sprite2D
@onready var hitbox = $Hitbox
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var enemy_explode = $EnemyExplode


var coin = preload("res://Prefabs/Interactables/Coins.tscn")
var particles = preload("res://Prefabs/Particles/EnemyExplosion.tscn")
var is_alive = true

var dir = 1
func _ready():
	animation_player.play("Walk")
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2DDown.is_colliding() and is_on_floor():
		flip()
		
	if $RayCast2DLeft.is_colliding() or $RayCast2DRight.is_colliding():
		flip()
		$RayCast2DLeft.enabled = false
		$RayCast2DRight.enabled = false
		await get_tree().create_timer(0.5).timeout
		$RayCast2DLeft.enabled = true
		$RayCast2DRight.enabled = true
	
	if is_alive:
		velocity.x = speed
	else:
		velocity.x = 0
	move_and_slide()

func flip():
	is_going_right = !is_going_right
	scale.x = abs(scale.x) * -dir
	
	if is_going_right:
		speed = abs(speed) * dir
	else:
		speed = abs(speed) * -dir

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		GameManager.health -= 10
		GameManager.is_damage = true
		GameManager.play_hurtheal_animation = true

func take_damage():
	health -= 10
	animation_player.play("Hit")
	##Add knockback
	if health <= 0:
		for i in range(3, 0, -1):
			var instanced_coin = instantiate_coin()
			instanced_coin.spawn()
		var instanced_particles = instantiate_particles()
		instanced_particles.emitting = true
		sprite_2d.queue_free()
		hitbox.queue_free()
		collision_shape_2d.queue_free()
		gravity = 0
		is_alive = false
		enemy_explode.playing = true


func instantiate_particles():
	var instance = particles.instantiate()
	add_child(instance)
	instance.position = get_parent().position
	return instance

func instantiate_coin():
	var instance = coin.instantiate()
	add_child(instance)
	instance.position.x += randi() % 10 + 1
	instance.position.y -= randi() % 100 + 1
	return instance

func _on_player_knockback():
	knockback_dir = get_parent().get_parent().get_node("Player").dir
	dir = knockback_dir * -1
	knockback = true
