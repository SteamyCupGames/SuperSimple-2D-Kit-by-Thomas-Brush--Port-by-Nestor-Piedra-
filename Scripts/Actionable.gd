### Extra help on the Dialogue System
### https://www.youtube.com/watch?v=UhPFk8FSbd8&list=PLWEX_DQyaQyyquh1NHU2onWyYUsfQCI_3
extends Area2D

const CustomTextBalloon = preload("res://Prefabs/Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	var balloon: Node = CustomTextBalloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
