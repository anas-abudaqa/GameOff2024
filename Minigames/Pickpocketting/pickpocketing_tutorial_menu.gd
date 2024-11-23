extends Control

const MINIGAMESCENE: PackedScene = preload("res://Minigames/Pickpocketting/Pickpocketing.tscn")
const MAINSCENE: PackedScene = preload("res://Levels/main_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_start_button_pressed():
	get_tree().change_scene_to_packed(MINIGAMESCENE)


func _on_quit_button_pressed():
	#MainLevel saves last player position before teleporting to new game
	get_tree().change_scene_to_packed(MAINSCENE)
