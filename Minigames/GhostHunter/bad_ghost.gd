extends Ghost


func _ready():
	score = -5
	expiry_timer.start()
#

func _on_assigned_letter_pressed(letter: String):
	if letter == assigned_letter:
		GhostDespawned.emit(assigned_letter, score, effect)
		#add music
		queue_free()
#

