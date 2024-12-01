extends Node

const MAIN_LEVEL = preload("res://Levels/main_level.tscn")

var has_lab_key: bool = false
var has_heart: bool = false
var swap_syndra_sprite: bool = false
var obtained_brainjar7: bool = false
var obtained_undeadheart: bool = false
var obtained_damnedtongue: bool = false
var obtained_sacrificeblood: bool = false
var cave_locked: bool = true
var syndra_transformed: bool = false
var syndra_chapter_moved: bool = false
var player_spawn_location: Vector2 = Vector2.ZERO
var game_just_started: bool = true

var game_timer


func _ready():
	game_timer = get_tree().create_timer(1800)

func _on_pickpocket_won():
	has_lab_key = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)
	Dialogic.start("Obtained_LabKey")

func _on_heartpiecer_won():
	#has_heart = true
	obtained_undeadheart = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)
	Dialogic.start("Melded_Heart")

func _on_ghosthunt_won():
	#has_heart = true
	#obtained_undeadheart = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)
	Dialogic.start("Ghosts_Wacked")
