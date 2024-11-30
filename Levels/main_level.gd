extends Node2D


const PICKPOCKETING_TUTORIAL_MENU = preload("res://Minigames/Pickpocketting/pickpocketing_tutorial_menu.tscn")
const HEARTPIECER_TUTORIAL_MENU = preload("res://Minigames/HeartPiecer/heartpiecer_tutorial_menu.tscn")
const GHOSTHUNTER_TUTORIAL_MENU = preload("res://Minigames/GhostHunter/ghosthunter_tutorial_menu.tscn")
const SHED_INTERIOR = preload("res://Levels/shed_interior.tscn")
const CULTESPIONAGE_TUTORIAL_MENU = preload("res://Minigames/CultEspionage/cultespionage_tutorial_menu.tscn")

@onready var syndra_marker_1 = $SyndraMarker1
@onready var syndra = $Syndra
@onready var star_entrance = $Graveyard/StarEntrance

var player_node: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = find_child("Player")
	if player_node and AllKnowing.player_spawn_location:
		player_node.global_position = AllKnowing.player_spawn_location
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if AllKnowing.obtained_brainjar7 and AllKnowing.obtained_undeadheart:
		syndra.global_position = syndra_marker_1.global_position
		Dialogic.VAR.SyndraQuest.current_chapter = 4

func store_player_position():
	AllKnowing.player_spawn_location = player_node.global_position

func _on_dialogic_signal(trigger: String):
	match trigger:
		"Pickpocket":
			store_player_position()
			get_tree().change_scene_to_packed(PICKPOCKETING_TUTORIAL_MENU)
		"Heartpiecer":
			store_player_position()
			get_tree().change_scene_to_packed(HEARTPIECER_TUTORIAL_MENU)
		"UndeadHeart":
			Dialogic.start("Obtained_Undead_Heart")
		"GhostHunt":
			store_player_position()
			get_tree().change_scene_to_packed(GHOSTHUNTER_TUTORIAL_MENU)
		"UnlockEntrance":
			star_entrance.unlock_entrance()

func _on_shed_exterior_enter_shed():
	store_player_position()
	get_tree().change_scene_to_packed(SHED_INTERIOR)


func _on_star_entrance_enter_cave():
	if !AllKnowing.obtained_sacrificeblood:
		store_player_position()
		get_tree().change_scene_to_packed(CULTESPIONAGE_TUTORIAL_MENU)
	else:
		Dialogic.start("BlockEntrance")
