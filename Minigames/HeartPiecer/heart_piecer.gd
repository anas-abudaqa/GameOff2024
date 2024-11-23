extends Node2D

signal HeartPiecerWon

@onready var image_pieces = $Round1ImagePieces
@onready var image_piece_1 = $Round1ImagePieces/ImagePiece1
@onready var image_piece_2 = $Round1ImagePieces/ImagePiece2
@onready var image_piece_3 = $Round1ImagePieces/ImagePiece3
@onready var image_piece_last = $Round1ImagePieces/ImagePieceLast

@onready var round_2_image_pieces = $Round2ImagePieces



@onready var round_3_image_pieces = $Round3ImagePieces


@onready var rich_text_label = $UI/RichTextLabel
@onready var round_transition_timer = $RoundTransitionTimer
@onready var round_timer = $RoundTimer

#round number: round image pieces
@onready var remaining_rounds_dictionary: Dictionary = {
	1: image_pieces,
	2: image_pieces,
	3: round_3_image_pieces
}

const NUMBER_OF_PIECES: int = 4
const DISPLACEMENT_ANGLE: int = 40
#const HEARTPIECER_TUTORIAL_MENU = preload("res://Minigames/HeartPiecer/heartpiecer_tutorial_menu.tscn")


var game_started: bool = false
var correct_alignments: int = 0
var tries_left: int = 3
var current_round_images

# Called when the node enters the scene tree for the first time.
func _ready():
	tries_left = 3
	start_round()
	#print(remaining_rounds_dictionary)

func _process(delta):
	rich_text_label.text = "Round: " + str(remaining_rounds_dictionary.find_key(current_round_images)) + "     Time Left: " + str(int(round_timer.time_left))
	
	#print(game_started)
	
	
func start_round():
	var key_array = remaining_rounds_dictionary.keys()
	if !key_array:
		game_won()
	var next_round_images = remaining_rounds_dictionary.get(key_array[0])
	current_round_images = next_round_images
	
	#make the current set of images visible
	current_round_images.visible = true
	var angle_multiplier: int = 2
	#set starting positions
	for child in current_round_images.get_children():
		child.rotation_degrees += angle_multiplier * DISPLACEMENT_ANGLE
		angle_multiplier *= -2
	
	#set alignments to 0
	correct_alignments = 0
	#unpause game
	game_started = true
	#start round timer
	round_timer.start()
	
	
	
func round_won():
	game_started = false
	round_timer.stop()
	clear_modulate(image_pieces)
	print("ROUND WON")
	round_transition_timer.start()

func round_lost():
	print("You ran out of time. Try again")
	start_round()

func game_won():
	await get_tree().create_timer(1.5).timeout
	HeartPiecerWon.emit()

func game_lost():
	pass
	#get_tree().change_scene_to_packed(HEARTPIECER_TUTORIAL_MENU)	
	
func clear_modulate(images: Node2D):
	for child in images.get_children():
		child.modulate = Color("ffffff")

#Movements

func base_movement(image: Area2D, event: InputEvent):
	if !game_started:
		return
	if event.is_action_pressed("LMB"):
		image.rotation_degrees += DISPLACEMENT_ANGLE
	elif event.is_action_pressed("RMB"):
		image.rotation_degrees -= DISPLACEMENT_ANGLE


func _on_alignment_area_area_entered(area):
	correct_alignments += 1
	print(correct_alignments, " Aligned!")
	if correct_alignments == NUMBER_OF_PIECES:
		round_won()


func _on_alignment_area_area_exited(area):
	correct_alignments -= 1
	correct_alignments = clamp(correct_alignments, 0, NUMBER_OF_PIECES)
	print(correct_alignments, " Misaligned!")


func _on_image_piece_1_input_event(viewport, event, shape_idx):
	#print("are we clicking?")
	base_movement(image_piece_1, event)


func _on_image_piece_2_input_event(viewport, event, shape_idx):
	base_movement(image_piece_2, event)


func _on_image_piece_3_input_event(viewport, event, shape_idx):
	base_movement(image_piece_3, event)


func _on_image_piece_last_input_event(viewport, event, shape_idx):
	base_movement(image_piece_last, event)


func _on_round_timer_timeout():
	tries_left -= 1
	if tries_left <= 0:
		game_lost()
	else:
		round_lost()


func _on_round_transition_timer_timeout():
	current_round_images.visible = false
	var expired_key = remaining_rounds_dictionary.find_key(current_round_images)
	remaining_rounds_dictionary.erase(expired_key)
	start_round() 
