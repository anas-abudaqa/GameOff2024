extends Node2D

@onready var enemies = $Enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemies.get_children():
		enemy.connect("PlayerDetected", _on_player_detected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_lost():
	print("you got detected")

func _on_player_detected():
	game_lost()
