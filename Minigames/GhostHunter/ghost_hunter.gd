extends Node2D

signal LetterPressed(letter: String)

@onready var ghost_container = $GhostContainer
@onready var position_markers_container = $PositionMarkersContainer
@onready var rounds_container = $RoundsContainer


@onready var score_progress_bar = $ScoreProgressBar
@onready var game_timer = $Control/GameTimer
@onready var timer_label = $Control/TimerLabel

const WINNING_SCORE: int = 100

var total_score: int = 0

var unused_letter_array: Array = ["Q", "W", "E", "S", "A", "D", "Z", "X", "C", "R", "F", "V"]
var used_letter_array: Array

var good_ghost_scene = preload("res://Minigames/GhostHunter/ghost.tscn")
var bad_ghost_scene = preload("res://Minigames/GhostHunter/bad_ghost.tscn")

var rng = RandomNumberGenerator.new()

var current_round: Line2D
var current_round_index: int = 0
var current_round_array: PackedVector2Array

var max_slots: int
var current_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	score_progress_bar.max_value = WINNING_SCORE
	
	#turn off visibility of each marker2D in the container. Use visibility state to check if a spot is used or not
	for child in position_markers_container.get_children(): 
		child.visible = false
	for child in rounds_container.get_children(): 
		child.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer_label.text = str(int(game_timer.time_left))

func _unhandled_input(event):
	#var block_input: bool = false
	for letter in used_letter_array:
		if letter == event.as_text():
			#if !block_input:
			#block_input = true
			LetterPressed.emit(letter)
			#else:
				#block_input = false

func assign_letter() -> String:
	if unused_letter_array.size() > 0:
		var random_letter = unused_letter_array.pick_random()
			#remove from unused letter array
		unused_letter_array.erase(random_letter)
			#add to used letter array to use for input detection
		used_letter_array.append(random_letter)
		return random_letter
	else:
		print("All letters are in use")
		return ""
		

func spawn_ghost():
	var ghost_instance
	#decide to spawn good cat or bad cat. Biased towards good cat
	var rand_number = rng.randf_range(0, 1) 
	if rand_number > 0.5:
		ghost_instance = good_ghost_scene.instantiate()
	else:
		ghost_instance = bad_ghost_scene.instantiate()
	
	#Assign letter to cat instance
	ghost_instance.assigned_letter = assign_letter()
	#If assigned letter is not empty, aka array wasn't empty
	if ghost_instance.assigned_letter:
		#add to correct parent
		ghost_container.add_child(ghost_instance)
		#connect the signal CatDespawned from the cat to our  append function
		ghost_instance.connect("GhostDespawned", _consume_ghost)
		# connect our signal LetterPressed to the cat instance's letter pressed function
		LetterPressed.connect(Callable(ghost_instance, "_on_assigned_letter_pressed"))
		#get spawn coordinates
		var spawn_location: Vector2 = get_spawn_coordinates()
		#spawn after assigning letter so label is correct
		if spawn_location:
			ghost_instance.spawn(spawn_location)
		else: #If array is empty aka max simultanous cat spawns reached, delete cat
			ghost_instance.queue_free()
	else: #If array is empty aka max simultanous cat spawns reached, delete cat
		ghost_instance.queue_free()
	
func get_spawn_coordinates() -> Vector2:
	#check if we aren't at max slots first
	if current_slot < max_slots:
		return current_round_array[current_slot]
	else:
		round_done()
		return Vector2.ZERO

func round_done():
	if current_round_index < rounds_container.get_child_count():
		current_round_index += 1
		spawn_round()

func _consume_ghost(letter: String, score: int, ghost_position: Vector2):
	#clear_marker(ghost_position)
	unused_letter_array.append(letter)
	used_letter_array.erase(letter)
	total_score += score
	total_score = clamp(total_score, 0, WINNING_SCORE)
	print("Score is now: ", total_score)
	#update score on label
	score_progress_bar.value = total_score
	if total_score >= WINNING_SCORE:
		print("WE WON")
	#go to next slot
	current_slot += 1
	spawn_ghost()
	
	
func spawn_round():
	#for child in rounds_container.get_children():
		#if !child.visible:
			#current_round.queue_free() 
			#current_round = child
			#child.visible = true
			#print("We chose: ", current_round)
			#break 
	if current_round:
		current_round.visible = false
		
	var rounds = rounds_container.get_children()
	current_round = rounds[current_round_index]
	current_round.visible = true
	
	max_slots = current_round.get_point_count()
	current_round_array = current_round.get_points()
	current_slot = 0
	await get_tree().create_timer(1.5).timeout
	#for point_position in points_array:
	spawn_ghost()




func _on_timer_timeout():
	spawn_round()
	##Autorestart, multiple shot timer 
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()
	#spawn_ghost()


func _on_game_timer_timeout():
	print("Time Out!")
