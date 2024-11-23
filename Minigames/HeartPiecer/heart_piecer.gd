extends Node2D

signal HeartPiecerWon

@onready var image_pieces = $Round1ImagePieces
@onready var image_piece_1 = $Round1ImagePieces/ImagePiece1
@onready var image_piece_2 = $Round1ImagePieces/ImagePiece2
@onready var image_piece_3 = $Round1ImagePieces/ImagePiece3
@onready var image_piece_last = $Round1ImagePieces/ImagePieceLast

@onready var round_2_image_pieces = $Round2ImagePieces
@onready var image_piece_r_21 = $Round2ImagePieces/ImagePieceR21
@onready var image_piece_r_22 = $Round2ImagePieces/ImagePieceR22
@onready var image_piece_r_23 = $Round2ImagePieces/ImagePieceR23
@onready var image_piece_r_2_last = $Round2ImagePieces/ImagePieceR2Last

@onready var round_3_image_pieces = $Round3ImagePieces
@onready var image_piece_r_31 = $Round3ImagePieces/ImagePieceR31
@onready var image_piece_r_32 = $Round3ImagePieces/ImagePieceR32
@onready var image_piece_r_33 = $Round3ImagePieces/ImagePieceR33
@onready var image_piece_r_3_last = $Round3ImagePieces/ImagePieceR3Last


@onready var rich_text_label = $UI/RichTextLabel
@onready var round_transition_timer = $RoundTransitionTimer
@onready var round_timer = $RoundTimer
@onready var heartbeat_animation = $HeartbeatAnimation

#round number: round image pieces
var remaining_rounds_dictionary: Dictionary = {}

const NUMBER_OF_PIECES: int = 4
const DISPLACEMENT_ANGLE: int = 40
#const HEARTPIECER_TUTORIAL_MENU = preload("res://Minigames/HeartPiecer/heartpiecer_tutorial_menu.tscn")
const HEARTPIECER_TUTORIAL_MENU = preload("res://Minigames/HeartPiecer/heartpiecer_tutorial_menu.tscn")

var game_started: bool = false
var correct_alignments: int = 0
var tries_left: int = 3
var current_round_images

# Called when the node enters the scene tree for the first time.
func _ready():
	HeartPiecerWon.connect(AllKnowing._on_heartpiecer_won)
	remaining_rounds_dictionary = {
		1: image_pieces,
		2: round_2_image_pieces,
		3: round_3_image_pieces
	}
	image_pieces.visible = false
	round_2_image_pieces.visible = false
	round_3_image_pieces.visible = false
	tries_left = 3
	start_round()

func _process(_delta):
	rich_text_label.text = "Round: " + str(remaining_rounds_dictionary.find_key(current_round_images)) + "     Time Left: " + str(int(round_timer.time_left))
	
	
func start_round():
	if current_round_images:
		current_round_images.visible = false
	var key_array = remaining_rounds_dictionary.keys()
	if !key_array:
		game_won()
		return
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
	clear_modulate()
	print("ROUND WON")
	round_transition_timer.start()

func round_lost():
	print("You ran out of time. Try again")
	start_round()

func game_won():
	rich_text_label.visible = false
	heartbeat_animation.visible = true
	heartbeat_animation.play("Idle")
	await get_tree().create_timer(5).timeout
	HeartPiecerWon.emit()

func game_lost():
	get_tree().change_scene_to_packed(HEARTPIECER_TUTORIAL_MENU)	
	
func clear_modulate():
	for child in current_round_images.get_children():
		child.modulate = Color("ffffff")

#Movements

func base_movement(image: Area2D, event: InputEvent):
	if !game_started:
		return
	if event.is_action_pressed("LMB"):
		image.rotation_degrees += DISPLACEMENT_ANGLE
	elif event.is_action_pressed("RMB"):
		image.rotation_degrees -= DISPLACEMENT_ANGLE

func _on_round_timer_timeout():
	tries_left -= 1
	if tries_left <= 0:
		game_lost()
	else:
		round_lost()

func _on_round_transition_timer_timeout():
	var expired_key = remaining_rounds_dictionary.find_key(current_round_images)
	remaining_rounds_dictionary.erase(expired_key)
	start_round() 

func _on_alignment_area_area_entered(_area):
	correct_alignments += 1
	print(correct_alignments, " Aligned!")
	if correct_alignments == NUMBER_OF_PIECES:
		round_won()


func _on_alignment_area_area_exited(_area):
	correct_alignments -= 1
	correct_alignments = clamp(correct_alignments, 0, NUMBER_OF_PIECES)
	print(correct_alignments, " Misaligned!")


func _on_image_piece_1_input_event(_viewport, event, _shape_idx):
	#print("are we clicking?")
	base_movement(image_piece_1, event)


func _on_image_piece_2_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_2, event)


func _on_image_piece_3_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_3, event)


func _on_image_piece_last_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_last, event)


func _on_image_piece_r_21_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_21, event)


func _on_image_piece_r_22_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_22, event)


func _on_image_piece_r_23_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_23, event)


func _on_image_piece_r_2_last_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_2_last, event)


func _on_image_piece_r_31_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_31, event)


func _on_image_piece_r_32_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_32, event)


func _on_image_piece_r_33_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_33, event)


func _on_image_piece_r_3_last_input_event(_viewport, event, _shape_idx):
	base_movement(image_piece_r_3_last, event)
