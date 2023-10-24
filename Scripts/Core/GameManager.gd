extends Node

############# Signals ###########
signal receivedCoins(int)

############# Variables ###########
var coins = 0
var camera : Camera2D
var player : CharacterBody2D
var health = 100
const MAX_HEALTH = 100
var canInteract = false
var has_key = false
var is_hud_available = true

var play_hurtheal_animation = false
var down_attack_unlocked = true
var is_damage = false
		
func _ready():
	health = 100
	coins = 0
	
func _process(_delta):
	if health <= 0:
		set_process_input(false)
		player.get_child(0).visible = false
		player.get_child(1).disabled = true
		player.get_child(6).emitting = true
		health = MAX_HEALTH
		await get_tree().create_timer(2).timeout
		SceneTransition.change_scene("res://Scenes/Level1.tscn")

func gain_coins(coinsCollected):
	coins += coinsCollected
	emit_signal("receivedCoins", coinsCollected)
