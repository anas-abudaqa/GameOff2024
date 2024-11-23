extends Node2D

const PICKPOCKETING_TUTORIAL_MENU = preload("res://Minigames/Pickpocketting/pickpocketing_tutorial_menu.tscn")

var player_node: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = find_child("Player")
	print("Allknowing location", AllKnowing.player_spawn_location)
	print("Player location ", player_node.global_position)
	if player_node and AllKnowing.player_spawn_location:
		player_node.global_position = AllKnowing.player_spawn_location
	Dialogic.signal_event.connect(_on_dialogic_signal)



func _on_dialogic_signal(minigame: String):
	match minigame:
		"Pickpocket":
			AllKnowing.player_spawn_location = player_node.global_position
			get_tree().change_scene_to_packed(PICKPOCKETING_TUTORIAL_MENU)
		_:
			print("Cum")
