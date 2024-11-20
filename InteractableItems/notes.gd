extends Area2D

@export var note_number: int


func interact():
	read_note()
	

func read_note():
	match note_number:
		0:
			Dialogic.start("Notes_Perception")
		1:
			Dialogic.start("Notes_Consciousness")
		2:
			Dialogic.start("Notes_Logic")
		3:
			Dialogic.start("Notes_Emotion")
		4:
			Dialogic.start("Notes_MotorControl")
		5:
			Dialogic.start("Notes_MotorControl")

