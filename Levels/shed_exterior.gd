extends Area2D

signal EnterShed

#const SHED_INTERIOR_SCENE = "res://Levels/shed_interior.tscn"
# Called when the node enters the scene tree for the first time.


func interact():
	prompt_door()
	

func prompt_door():
	if !AllKnowing.has_lab_key:
		Dialogic.start("Lab_Locked")
	else: 
		EnterShed.emit()
