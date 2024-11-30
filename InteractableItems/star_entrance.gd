extends Node2D

signal EnterCave

@onready var sprite_2d = $Sprite2D
@onready var entrance = $Entrance

#var is_locked: bool = true

func _ready():
	if AllKnowing.cave_locked:
		entrance.visible = false
	else:
		entrance.visible = true

func interact():
	if AllKnowing.cave_locked:
		if AllKnowing.obtained_damnedtongue: 
			Dialogic.start("Unlock_Star")
		else:
			Dialogic.start("Weird_Star")
	else:
		enter()
		

##called by main level when dialogic emits signal
func unlock_entrance():
	AllKnowing.cave_locked = false
	#is_locked = false
	entrance.visible = true

func enter():
	EnterCave.emit()
