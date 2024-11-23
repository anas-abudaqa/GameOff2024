extends Area2D



func interact():
	grab_jar()
	

func grab_jar():
	AllKnowing.obtained_brainjar7 = true
	Dialogic.start("ObtainedBrainJar")
	queue_free()
