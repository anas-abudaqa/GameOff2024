extends Node2D

@onready var timer_text = $TimerText

var timer_time: float = 1800

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#AllKnowing.game_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer_text.text = str(int(timer_time - AllKnowing.game_timer.time_left))
