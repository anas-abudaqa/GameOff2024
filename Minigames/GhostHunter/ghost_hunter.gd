extends Node2D

signal LetterPressed(letter: String)
signal GhostHuntWon

const GHOSTHUNTER_TUTORIAL_MENU = preload("res://Minigames/GhostHunter/ghosthunter_tutorial_menu.tscn")

@onready var ghost_container = $GhostContainer
@onready var position_markers_container = $PositionMarkersContainer
@onready var rounds_container = $RoundsContainer

@onready var curse_timer = $CurseTimer
@onready var curse_label = $UI/CurseLabel
@onready var round_label = $UI/RoundLabel
@onready var score_label = $UI/ScoreLabel

@onready var game_timer = $UI/GameTimer
#@onready var score_progress_bar = $UI/ScoreProgressBar

const WINNING_SCORE: int = 200
var good_ghost_scene = preload("res://Minigames/GhostHunter/ghost.tscn")
var bad_ghost_scene = preload("res://Minigames/GhostHunter/bad_ghost.tscn")
var curse_ghost_scene = preload("res://Minigames/GhostHunter/curse_ghost.tscn")
var mirror_ghost_scene = preload("res://Minigames/GhostHunter/mirror_ghost.tscn")

var total_score: int = 0

var unused_letter_array: Array = ["Q", "W", "E", "S", "A", "D", "Z", "X", "C", "R", "F", "V"]
var used_letter_array: Array

var rng = RandomNumberGenerator.new()
var good_ghosts_amount: int = int(floor(unused_letter_array.size()/2))
var is_cursed: bool = false

var current_round: Line2D
var current_round_index: int = 0
var current_round_array: PackedVector2Array
var max_slots: int
var current_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GhostHuntWon.connect(AllKnowing._on_ghosthunt_won)
	#score_progress_bar.max_value = WINNING_SCORE
	curse_label.visible = false
	#turn off visibility of each marker2D in the container. Use visibility state to check if a spot is used or not
	for child in position_markers_container.get_children(): 
		child.visible = false
	for child in rounds_container.get_children(): 
		child.visible = false
	
	await get_tree().create_timer(1.5).timeout
	spawn_round()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	round_label.text = "Round: " + str(current_round_index)

func _unhandled_input(event):
	if !is_cursed:
		for letter in used_letter_array:
			if letter == event.as_text():
				LetterPressed.emit(letter)
	else:
		print("Cursed bro")
		return


func spawn_round():

	#turn off visbility of current round before proceeeding
	#check if there is a current round first (in the first round this variable is not yet set)
	#if current_round:
		#current_round.visible = false
	
	#if it's  empty (in the first round it is never empty, so we need to add this check)
	#if unused_letter_array.size() == 0:
		##move all used letters back to unused letters before clearing used letters
		#unused_letter_array.append_array(used_letter_array)
		#used_letter_array.clear()
	
	var rounds = rounds_container.get_children()
	current_round = rounds[current_round_index]
	#current_round.visible = true
	
	max_slots = current_round.get_point_count()
	current_round_array = current_round.get_points()
	current_slot = 0
	
	#index starts at 0, so we add 1 to display correct round number
	round_label.text = "Round: " + str(current_round_index + 1)
	
	#wait for 1.5s before spawning a ghost
	await get_tree().create_timer(1.5).timeout
	spawn_ghost()

func spawn_ghost():
	var ghost_instance: Node2D = choose_ghost_type()
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

func choose_ghost_type():
	var rand_number: float = rng.randf()
	if current_round_index < 2:
		if rand_number <= 0.65:
			return good_ghost_scene.instantiate()
		else:
			return bad_ghost_scene.instantiate()
	
	elif current_round_index < 4:
		if rand_number <= 0.5:
			return good_ghost_scene.instantiate()
		elif rand_number <= 0.7:
			return mirror_ghost_scene.instantiate()
		else:
			return bad_ghost_scene.instantiate()
		
	elif current_round_index < 6:
		if rand_number <= 0.4:
			return good_ghost_scene.instantiate()
		elif rand_number <= 0.7:
			return mirror_ghost_scene.instantiate()
		elif rand_number <= 0.9:
			return bad_ghost_scene.instantiate()
		else: 
			return curse_ghost_scene.instantiate()
	
	else:
		if rand_number <= 0.3:
			return good_ghost_scene.instantiate()
		elif rand_number <= 0.6:
			return mirror_ghost_scene.instantiate()
		elif rand_number <= 0.8:
			return bad_ghost_scene.instantiate()
		else: 
			return curse_ghost_scene.instantiate()

func _consume_ghost(letter: String, score: int, effect: String):
	total_score += score
	total_score = clamp(total_score, 0, WINNING_SCORE)
	#print("Score is now: ", total_score)
	score_label.text = "Score: " + str(total_score)
	
	#if total_score >= WINNING_SCORE:
		#print("WE WON")
	
	#go to next slot
	current_slot += 1
	
	#apply curse effect  and screen text
	if effect == "CURSE":
		is_cursed = true
		curse_label.visible = true
		curse_timer.start()
	spawn_ghost()

#Round is done if we run out of letters to assign
func assign_letter() -> String:
	if unused_letter_array.size() > 0:
		var random_letter = unused_letter_array.pick_random()
			#remove from unused letter array
		unused_letter_array.erase(random_letter)
			#add to used letter array to use for input detection
		used_letter_array.append(random_letter)
		return random_letter
	else:
		##IDK IF THIS WILL CAUSE A BUG. WILL IT EVER RETURN IF I CALL ROUND_DONE FIRST?
		round_done()
		return ""

#Round is also done if we run out of slots to spawn ghosts in
func get_spawn_coordinates() -> Vector2:
	#check if we aren't at max slots first
	if current_slot < max_slots:
		return current_round_array[current_slot]
	else:
		round_done()
		return Vector2.ZERO


func round_done():
	#check if we have enough score to win the game
	if total_score >= WINNING_SCORE:
		game_won()
		return
	
	#if the current round index is less than how many total rounds there are in the rounds container
	if unused_letter_array.size() == 0:
		#move all used letters back to unused letters before clearing used letters
		unused_letter_array.append_array(used_letter_array)
		used_letter_array.clear()
	
	#if round index is smaller than how many rounds there are
	#round index starts from 0, gget_child_count starts from 1
	if current_round_index < rounds_container.get_child_count() - 1:
		#increment index and spawn new round
		current_round_index += 1
		spawn_round()
	else:
		game_lost()

func game_won():
	await get_tree().create_timer(1.5).timeout
	GhostHuntWon.emit()

func game_lost():
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(GHOSTHUNTER_TUTORIAL_MENU)

func _on_game_timer_timeout():
	print("Time Out!")

func _on_curse_timer_timeout():
	is_cursed = false
	curse_label.visible = false
