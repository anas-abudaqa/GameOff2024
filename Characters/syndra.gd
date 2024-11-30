extends Area2D

@onready var cat = $Cat
@onready var syndra = $Syndra

#var transformed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if AllKnowing.syndra_transformed:
		syndra.visible = true 
		cat.visible = false
	else:
		syndra.visible = false
		cat.visible = true


func interact():
	start_dialogue_chapter(Dialogic.VAR.SyndraQuest.current_chapter)

func _on_dialogic_signal(argument: String):
	if argument == "SyndraTransform":
		syndra.visible = true 
		cat.visible = false
		AllKnowing.syndra_transformed = true

func start_dialogue_chapter(chapter: int):
	match(chapter):
		1:
			Dialogic.start("Syndra_Chapter1")
		2:
			Dialogic.start("Syndra_Chapter2")
		3:
			Dialogic.start("Syndra_Chapter3")
		4:
			Dialogic.start("Syndra_Chapter4")
		5:
			Dialogic.start("Syndra_Chapter5")
		6:
			Dialogic.start("Syndra_Chapter6")
		7:
			Dialogic.start("Syndra_Chapter7")
