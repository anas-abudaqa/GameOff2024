extends Area2D

func interact():
	start_dialogue_chapter(Dialogic.VAR.EzekielQuest.current_chapter)

func start_dialogue_chapter(chapter: int):
	match(chapter):
		1:
			Dialogic.start("Ezekial_Chapter1")
		2:
			Dialogic.start("Ezekial_Chapter2")
		3:
			Dialogic.start("Ezekiel_Chapter3")
		4:
			Dialogic.start("Ezekiel_Chapter4")
		5:
			Dialogic.start("Ezekiel_Chapter5")
		6:
			Dialogic.start("Ezekiel_Chapter6")
