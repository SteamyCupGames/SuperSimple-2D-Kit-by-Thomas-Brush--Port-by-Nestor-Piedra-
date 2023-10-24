extends CanvasLayer

@onready var main = $"../"
		
func _on_resume_pressed():
	main.pauseMenu()

func _on_restart_pressed():
	SceneTransition.change_scene("res://Scenes/Level1.tscn")
	Engine.time_scale = 1

func _on_quit_pressed():
	SceneTransition.change_scene("res://Scenes/MainMenu.tscn")
	Engine.time_scale = 1
