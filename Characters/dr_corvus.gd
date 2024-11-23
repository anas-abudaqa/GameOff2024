extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	start_dialogue_chapter(Dialogic.VAR.CorvusQuest.current_chapter)
	
	
func start_dialogue_chapter(chapter: int):
	#print("this is our chapter: ", chapter)
	match(chapter):
		1:
			Dialogic.start("Corvus_Chapter1")
		2:
			Dialogic.start("Corvus_Chapter2")
		3:
			Dialogic.start("Corvus_Chapter3")
		4:
			Dialogic.start("Corvus_Chapter4")
		5:
			Dialogic.start("Corvus_Chapter5")
		6:
			Dialogic.start("Corvus_Chapter6")
