extends Area2D

@export var redirection_to: String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_area_entered(area):
	#print("Redirect")
	#print(area)
	area.movement_direction = redirection_to
	area.change_direction()
