extends CharacterBody2D
class_name Player
############# Signals ###########
signal collected(collectable)
signal knockback()
############# Serialized Variables ###########
@export var speed = 100.0
@export var jumpHeight = -300.0
@export var isFalling = false

############# References ###########
@onready var player_node = $"."
@onready var skeleton_2d = $Skeleton2D
@onready var animation_player = $AnimationPlayer
@onready var player_blast = $Skeleton2D/PlayerBlast
@onready var bone_spine_1 = $Skeleton2D/Bone_Spine1
@onready var actionable_finder = $Skeleton2D/Direction/ActionableFinder
@onready var jump_sound = $JumpSound
@onready var hit_sound = $HitSound
@onready var hurt_player = $HurtPlayer
@onready var jump_animation_player = $Skeleton2D/JumpEffect/JumpAnimationPlayer

###### Clean up references ######
@onready var chest_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/ChestSprite
@onready var head_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_Neck/Bone_Head/HeadSprite
@onready var eye_r_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_Neck/Bone_Head/Bone_EyeR/EyeRSprite
@onready var eye_l_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_Neck/Bone_Head/Bone_EyeL/EyeLSprite
@onready var bicep_r_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepR/BicepRSprite
@onready var arm_r_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepR/Bone_ArmR/ArmRSprite
@onready var hand_r_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepR/Bone_ArmR/Bone_HandR/HandRSprite
@onready var bicep_l_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepL/BicepLSprite
@onready var arm_l_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepL/Bone_ArmL/ArmLSprite
@onready var hand_l_sprite = $Skeleton2D/Bone_Spine1/Bone_Spine2/Bone_BicepL/Bone_ArmL/Bone_HandL/HandLSprite
@onready var thigh_l_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighL/ThighLSprite
@onready var calf_l_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighL/Bone_CalfL/CalfLSprite
@onready var foot_l_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighL/Bone_CalfL/Bone_FootL/FootLSprite
@onready var thigh_r_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighR/ThighR_sprite
@onready var calf_r_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighR/Bone_CalfR/CalfRSprite
@onready var foot_r_sprite = $Skeleton2D/Bone_Spine1/Bone_ThighR/Bone_CalfR/Bone_FootR/FootRSprite

############# Gameplay Variables ###########

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#knockback
var knockback_dir = Vector2()
var knockback_wait= 50

var is_hurt_playing = false
var dir

func _ready():
	GameManager.player = self
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta):
	## Cleaning process handled by code
	bone_spine_1.position = Vector2(0, 55)
	player_blast.visible = false
	chest_sprite.visible = true
	head_sprite.visible = true
	eye_r_sprite.visible = true
	eye_l_sprite.visible = true 
	bicep_r_sprite.visible = true
	arm_r_sprite.visible = true
	hand_r_sprite.visible = true
	bicep_l_sprite.visible = true
	arm_l_sprite.visible = true
	hand_l_sprite.visible = true
	thigh_l_sprite.visible = true
	calf_l_sprite.visible = true
	foot_l_sprite.visible = true
	thigh_r_sprite.visible = true
	calf_r_sprite.visible = true
	foot_r_sprite.visible = true
	
	#Flip player's sprite according to direction
	if Input.is_action_pressed("Left"):
		skeleton_2d.scale.x = -1
		dir = -1
	elif Input.is_action_pressed("Right"):
		skeleton_2d.scale.x = 1
		dir = 1
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 3.2 * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jumpHeight
		jump_sound.playing = true
		jump_animation_player.play("JumpEffects")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity.y <= 0:
		update_animations()
	else:
		animation_player.play("Fall")
	
	#Hit sound bug fix
	if Input.is_action_just_pressed("Hit"):
		hit_sound.playing = true
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		GameManager.camera.shake(10, 0.25)
		if Input.is_action_pressed("Up"):
			$Skeleton2D/Hitbox/CollisionShape2D.disabled = false
			animation_player.play("AttackUp")
		elif Input.is_action_pressed("Down") and not is_on_floor() and GameManager.down_attack_unlocked:
			$Skeleton2D/Hitbox/CollisionShape2D.disabled = false
			animation_player.play("AttackDown")
		elif not is_on_floor():
			$Skeleton2D/Hitbox/CollisionShape2D.disabled = false
			animation_player.play("AttackKick")
		else: 
			$Skeleton2D/Hitbox/CollisionShape2D.disabled = false
			animation_player.play("AttackPunch")
	else:
		$Skeleton2D/Hitbox/CollisionShape2D.disabled = true
	
	if GameManager.play_hurtheal_animation:
		animation_player.play("Health_Hurt")
		await get_tree().create_timer(0.05).timeout
		GameManager.play_hurtheal_animation = false
		if GameManager.is_damage:
			hurt_player.playing = true
			GameManager.is_damage = false	
	move_and_slide()
	
func update_animations():
	if velocity.x != 0:
		animation_player.play("Run")
	else:
		animation_player.play("Stand")
	if velocity.y < 0:
		animation_player.play("Jump")

func Collect(collectable):
	collected.emit(collectable)

func _on_hitbox_body_entered(body):
	if(body.is_in_group("Hit")):
		body.take_damage()
