extends Control

#const HEARTPIECER = preload("res://Minigames/HeartPiecer/heart_piecer.tscn")
const HEARTPIECER_PATH = "res://Minigames/HeartPiecer/heart_piecer.tscn"
const MAINSCENE: PackedScene = preload("res://Levels/main_level.tscn")

func _on_start_button_pressed():
	##Not sure why but changing to the packed scene causes a bug where the minigame screen is empty on retrying the game
	
	
	#get_tree().change_scene_to_packed(HEARTPIECER)
	get_tree().change_scene_to_file(HEARTPIECER_PATH)

func _on_quit_button_pressed():
	#MainLevel saves last player position before teleporting to new game
	get_tree().change_scene_to_packed(MAINSCENE)
