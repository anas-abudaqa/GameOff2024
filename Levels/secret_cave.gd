extends Node2D

@onready var enemies = $Enemies

const MAIN_LEVEL = preload("res://Levels/main_level.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemies.get_children():
		enemy.connect("PlayerDetected", _on_player_detected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	exit_cave()
	
func exit_cave():
	get_tree().change_scene_to_packed(MAIN_LEVEL)


func game_lost():
	#await get_tree().create_timer(1.5).timeout
	#get_tree().change_scene_to_packed()
	print("you got detected")

func _on_player_detected():
	game_lost()


