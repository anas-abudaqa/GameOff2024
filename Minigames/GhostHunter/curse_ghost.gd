extends Ghost

func _ready():
	score = 0
	effect = "CURSE"
	expiry_timer.start()
	
	
func _on_assigned_letter_pressed(letter: String):
	if letter == assigned_letter:
		print("Oh no ", letter, " ", score)
		GhostDespawned.emit(assigned_letter, score, effect)
		#add music
		queue_free()

func _on_expiry_timer_timeout():
	effect = ""
	GhostDespawned.emit(assigned_letter, score, effect)
	queue_free()
