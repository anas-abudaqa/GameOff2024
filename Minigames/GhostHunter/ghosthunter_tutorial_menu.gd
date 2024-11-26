extends Control


const MAINSCENE: PackedScene = preload("res://Levels/main_level.tscn")
const GHOSTHUNTER_PATH = "res://Minigames/GhostHunter/ghost_hunter.tscn"
func _on_start_button_pressed():
	##Duplicated from heartpiecer tutorial
	##Not sure why but changing to the packed scene causes a bug where the minigame screen is empty on retrying the game
	
	
	#get_tree().change_scene_to_packed(HEARTPIECER)
	get_tree().change_scene_to_file(GHOSTHUNTER_PATH)

func _on_quit_button_pressed():
	#MainLevel saves last player position before teleporting to new game
	get_tree().change_scene_to_packed(MAINSCENE)
