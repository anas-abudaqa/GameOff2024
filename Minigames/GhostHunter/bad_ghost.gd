extends Ghost

#signal GhostDespawned(assigned_letter: String, score: int, position: Vector2)
#
#var assigned_letter: String = ""
#var score: int = -5
#@onready var expiry_timer = $ExpiryTimer
#@onready var label = $Label
#
## Called when the node enters the scene tree for the first time.
func _ready():
	score = -5
	expiry_timer.start()
#
#func spawn(spawn_position: Vector2):
	#global_position = spawn_position
	#label.text = assigned_letter
#
##called when player presses the correct button, give letter and score
func _on_assigned_letter_pressed(letter: String):
	if letter == assigned_letter:
		print("Ha Ha fuck you ", letter, " ", score)
		GhostDespawned.emit(assigned_letter, score, global_position)
		queue_free()
#
#
##if expired, 0 score given but we still need to consume the letter
#func _on_expiry_timer_timeout():
	#GhostDespawned.emit(assigned_letter, 0, global_position)
	#queue_free()
