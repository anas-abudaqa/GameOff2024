extends Node2D


func interact():
	pick_up()
	
func pick_up():
	AllKnowing.has_heart = true
	Dialogic.start("Obtained_Heart")
