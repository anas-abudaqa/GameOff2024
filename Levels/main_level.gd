extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_node = find_child("Player")
	if player_node and AllKnowing.player_spawn_location:
		player_node.global_position = AllKnowing.player_spawn_location


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
