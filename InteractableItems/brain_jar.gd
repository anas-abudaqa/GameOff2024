extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	grab_jar()
	

func grab_jar():
	AllKnowing.obtained_brainjar7 = true
	Dialogic.start("ObtainedBrainJar")
	queue_free()
