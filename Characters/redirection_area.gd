extends Area2D

@export var redirection_to: String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	#print("Redirect")
	#print(area)
	area.movement_direction = redirection_to
	area.change_direction()
