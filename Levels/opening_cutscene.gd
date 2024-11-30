extends Node2D

const MAIN_LEVEL = "res://Levels/main_level.tscn"

@onready var shaman = $Shaman
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	await get_tree().create_timer(1).timeout
	Dialogic.start("Opening_Chapter1")

func _on_dialogic_signal(argument: String):
	if argument == "ShamanEnter":
		#shaman.movement_direction = "Left"
		shaman.can_move = true
		shaman.change_direction()
	
	elif argument == "ScreenFade":
		animation_player.play("BlackScreen")
		await get_tree().create_timer(1.5).timeout
		Dialogic.start("Opening_Chapter3")
	
	elif argument == "GameStart":
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file(MAIN_LEVEL)

func _on_redirection_area_area_entered(_area):
	await get_tree().create_timer(1).timeout
	Dialogic.start("Opening_Chapter2")
