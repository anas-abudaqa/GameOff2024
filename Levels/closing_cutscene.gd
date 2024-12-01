extends Node2D

@onready var animation_player = $AnimationPlayer
const END_GAME = preload("res://Levels/end_game.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	await get_tree().create_timer(1.5).timeout
	Dialogic.start("Closing_Chapter2")
	

func _on_dialogic_signal(argument: String):
	if argument == "Fade":
		animation_player.play("BlackScreen")
		Dialogic.start("Closing_Chapter3")
	elif argument == "EndGame":
		get_tree().change_scene_to_packed(END_GAME)
