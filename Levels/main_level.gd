extends Node2D

const PICKPOCKETING_TUTORIAL_MENU = preload("res://Minigames/Pickpocketting/pickpocketing_tutorial_menu.tscn")
const HEARTPIECER_TUTORIAL_MENU = preload("res://Minigames/HeartPiecer/heartpiecer_tutorial_menu.tscn")
const SHED_INTERIOR = preload("res://Levels/shed_interior.tscn")

var player_node: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = find_child("Player")
	if player_node and AllKnowing.player_spawn_location:
		player_node.global_position = AllKnowing.player_spawn_location
	Dialogic.signal_event.connect(_on_dialogic_signal)



func _on_dialogic_signal(minigame: String):
	match minigame:
		"Pickpocket":
			AllKnowing.player_spawn_location = player_node.global_position
			get_tree().change_scene_to_packed(PICKPOCKETING_TUTORIAL_MENU)
		"Heartpiecer":
			AllKnowing.player_spawn_location = player_node.global_position
			get_tree().change_scene_to_packed(HEARTPIECER_TUTORIAL_MENU)

func _on_shed_exterior_enter_shed():
	AllKnowing.player_spawn_location = player_node.global_position
	get_tree().change_scene_to_packed(SHED_INTERIOR)
