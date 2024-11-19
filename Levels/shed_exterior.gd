extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	prompt_door()
	

func prompt_door():
	if !AllKnowing.has_lab_key:
		Dialogic.start("Lab_Locked")
