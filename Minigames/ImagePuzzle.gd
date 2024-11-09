extends Node2D

@onready var image_piece_1 = $ImagePiece1
@onready var image_piece_2 = $ImagePiece2
@onready var image_piece_3 = $ImagePiece3

var mouse_is_hovering1: bool = false
var mouse_is_hovering2: bool = false
var mouse_is_hovering3: bool = false
var correct_alignments: int = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if correct_alignments >= 3:
		print("You Win")
	
	
func _unhandled_input(event):
	if event.is_action_pressed("LMB"):
		if mouse_is_hovering1:
			image_piece_1.rotation_degrees += 45
		elif mouse_is_hovering2:
			image_piece_2.rotation_degrees += 45
		elif mouse_is_hovering3:
			image_piece_3.rotation_degrees += 45
		else:
			return
	
func _on_image_piece_1_mouse_entered():
	mouse_is_hovering1 = true

func _on_image_piece_1_mouse_exited():
	mouse_is_hovering1 = false

func _on_image_piece_2_mouse_entered():
	mouse_is_hovering2 = true

func _on_image_piece_2_mouse_exited():
	mouse_is_hovering2 = false

func _on_image_piece_3_mouse_entered():
	mouse_is_hovering3 = true

func _on_image_piece_3_mouse_exited():
	mouse_is_hovering3 = false


func _on_alignment_area_area_entered(area):
	correct_alignments += 1
	print(correct_alignments, " Aligned!")
