extends Node2D

const MAIN_AREA_SCENE = preload("res://Levels/main_level.tscn") 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	leave_area()
	
func leave_area():
	AllKnowing.player_spawn_location = Vector2(-860, 100)
	get_tree().change_scene_to_packed(MAIN_AREA_SCENE)
