extends Area2D

signal GhostCorrectlyPlaced(assigned_number: int)
signal CorrectGhostRemoved(assigned_number: int)

@export var assigned_number: int

##Alignment spot should track its own collisions with ghosts, and if the ghost is the correct one or not

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	#snap to alignment position
	area.global_position = global_position
	area.ghost_selected = false
	#check if the assigned number
	if assigned_number == area.number:
		GhostCorrectlyPlaced.emit(area.number)


func _on_area_exited(area):
	if assigned_number == area.number:
		CorrectGhostRemoved.emit(area.number)
