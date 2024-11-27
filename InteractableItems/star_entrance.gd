extends Node2D


@onready var sprite_2d = $Sprite2D
@onready var entrance = $Entrance

var is_locked: bool = true

func _ready():
	entrance.visible = false

func interact():
	if is_locked:
		if AllKnowing.obtained_damnedtongue: 
			Dialogic.start("Unlock_Star")
		else:
			Dialogic.start("Weird_Star")
	else:
		enter()
		

func unlock_entrance():
	is_locked = false
	entrance.visible = true

func enter():
	print("Cum")
