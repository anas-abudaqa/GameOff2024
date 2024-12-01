extends Node2D

const OPENING_CUTSCENE = preload("res://Levels/opening_cutscene.tscn")
# Called when the node enters the scene tree for the first time.



func _on_button_pressed():
	get_tree().change_scene_to_packed(OPENING_CUTSCENE)
