extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("transition")
