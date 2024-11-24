extends Node2D

#

const MAIN_AREA_SCENE = preload("res://Levels/main_level.tscn") 
# Called when the node enters the scene tree for the first time.
func _ready():
	#LeaveShed.connect(AllKnowing._on_leave_shed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	leave_area()
	
func leave_area():
	#LeaveShed.emit()
	#AllKnowing.player_spawn_location = Vector2(-860, 100)
	get_tree().change_scene_to_packed(MAIN_AREA_SCENE)
