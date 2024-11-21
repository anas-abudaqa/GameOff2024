extends Node2D

var is_locked: bool = true
@onready var sprite_2d = $Sprite2D

func interact():
	if is_locked:
		if AllKnowing.obtained_damnedtongue: 
			unlock_entrance()
		else:
			Dialogic.start("Weird_Star")
	else:
		enter()
		

func unlock_entrance():
	is_locked = false

func enter():
	pass
