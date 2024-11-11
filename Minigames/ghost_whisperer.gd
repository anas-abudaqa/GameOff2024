extends Area2D

@export var number: int

var mouse_is_hovering: bool = false

# Ghost should detect only its own mouse and dragging movement

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("LMB") and mouse_is_hovering:
		#global_position = global_position.lerp(get_global_mouse_position(), delta*200) 
		global_position = get_global_mouse_position()

func _on_mouse_entered():
	mouse_is_hovering = true


func _on_mouse_exited():
	mouse_is_hovering = false
