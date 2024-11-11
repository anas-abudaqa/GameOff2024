extends Node2D

var correctly_placed_ghost_array: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if correctly_placed_ghost_array.size() == 2:
		print("We won")


func append_assigned_number(assigned_number: int):
	if assigned_number not in correctly_placed_ghost_array:
		correctly_placed_ghost_array.append(assigned_number)
		print("Yo this is aligned ", assigned_number)

func erase_assigned_number(assigned_number: int):
	if assigned_number in correctly_placed_ghost_array:
		correctly_placed_ghost_array.erase(assigned_number)
		print("Yo this is removed ", assigned_number)

func _on_alignment_spot_ghost_correctly_placed(assigned_number):
	append_assigned_number(assigned_number)
	


func _on_alignment_spot_2_ghost_correctly_placed(assigned_number):
	append_assigned_number(assigned_number)
	print("Yo this is aligned 2")



func _on_alignment_spot_ghost_removed(assigned_number):
	erase_assigned_number(assigned_number)


func _on_alignment_spot_2_ghost_removed(assigned_number):
	erase_assigned_number(assigned_number)
