extends CanvasLayer

func _on_start_game_pressed():
	SceneTransition.change_scene("res://Scenes/Level1.tscn")

func _on_quit_pressed():
	get_tree().quit()
