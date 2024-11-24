extends Node

var has_lab_key: bool = false
var has_heart: bool = false

var obtained_brainjar7: bool = false
var obtained_undeadheart: bool = false
var obtained_damnedtongue: bool = false
var obtained_sacrificeblood: bool = false


var player_spawn_location: Vector2 = Vector2.ZERO
const MAIN_LEVEL = preload("res://Levels/main_level.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pickpocket_won():
	has_lab_key = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)
	Dialogic.start("Obtained_LabKey")

func _on_heartpiecer_won():
	#has_heart = true
	obtained_undeadheart = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)
