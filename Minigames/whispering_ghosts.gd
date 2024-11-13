extends Node2D
@onready var alignment_spots = $AlignmentSpots

var correctly_placed_ghost_array: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in alignment_spots.get_children():
		child.connect("GhostCorrectlyPlaced", _append_assigned_number)
		child.connect("CorrectGhostRemoved", _erase_assigned_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if correctly_placed_ghost_array.size() == 10:
		print("We won")


func _append_assigned_number(assigned_number: int):
	if assigned_number not in correctly_placed_ghost_array:
		correctly_placed_ghost_array.append(assigned_number)
		print("Yo this is aligned ", assigned_number)

func _erase_assigned_number(assigned_number: int):
	if assigned_number in correctly_placed_ghost_array:
		correctly_placed_ghost_array.erase(assigned_number)
		print("We removed this one ", assigned_number)


