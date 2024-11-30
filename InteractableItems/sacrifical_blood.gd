extends Node2D


func interact():
	pick_up()
	

func pick_up():
	AllKnowing.obtained_sacrificeblood = true
	Dialogic.start("ObtainedSacrificeBlood")
	queue_free()
