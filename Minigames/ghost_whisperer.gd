extends Area2D

@export var number: int
@export var label_text: String
@onready var label = $Label
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var ghost_selected: bool = false

# Ghost should detect only its own mouse and dragging movement

func _ready():
	label.text = label_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ghost_selected:
		global_position = get_global_mouse_position()
		#global_position = global_position.lerp(get_global_mouse_position(), delta*200) 



#use the built in signal to better detect when we're on this shape specifically and prevent affecting multiple ghostwhisperers at once
func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		ghost_selected = true
	elif event.is_action_released("LMB"):
		ghost_selected = false
		audio_stream_player_2d.play()
		#global_position = get_global_mouse_position()
