extends Node2D

class_name  Ghost

signal GhostDespawned(assigned_letter: String, score: int, effect: String)

@onready var expiry_timer = $ExpiryTimer
@onready var label = $RichTextLabel

var assigned_letter: String = ""
var effect: String = ""
var score: int = 5
var lifetime: float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	expiry_timer.wait_time = lifetime
	expiry_timer.start()

func spawn(spawn_position: Vector2):
	global_position = spawn_position
	label.text = assigned_letter
	

#called when player presses the correct button, give letter and score
func _on_assigned_letter_pressed(letter: String):
	if letter == assigned_letter:
		print("Yo we got consumed by this letter and score ", letter, " ", score)
		GhostDespawned.emit(assigned_letter, score, effect)
		#add music
		queue_free()

	
#if expired, 0 score given but we still need to consume the	 letter
func _on_expiry_timer_timeout():
	GhostDespawned.emit(assigned_letter, 0, effect)
	queue_free()

