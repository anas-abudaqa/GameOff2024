extends Node2D

@onready var enemies = $Enemies
@onready var game_lost_audio = $GameLostAudio
@onready var game_lost_text = $Player/GameLostText

const MAIN_LEVEL = preload("res://Levels/main_level.tscn")
const CULTESPIONAGE_TUTORIAL_MENU = preload("res://Minigames/CultEspionage/cultespionage_tutorial_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	game_lost_text.visible = false
	for enemy in enemies.get_children():
		enemy.connect("PlayerDetected", _on_player_detected)


func interact():
	exit_cave()
	
func exit_cave():
	get_tree().change_scene_to_packed(MAIN_LEVEL)

func _on_player_detected():
	game_lost_text.visible = true
	get_tree().paused = true
	#game_lost_audio.play()
	await game_lost_audio.finished
	get_tree().paused = false
	game_lost()

func game_lost():
	#await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(CULTESPIONAGE_TUTORIAL_MENU)
	print("you got detected")

