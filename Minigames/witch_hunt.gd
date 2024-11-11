extends Node2D

signal LetterPressed(letter: String)

@onready var cats_container = $CatsContainer
@onready var score_progress_bar = $ScoreProgressBar
@onready var game_timer = $Control/GameTimer
@onready var timer_label = $Control/TimerLabel

const WINNING_SCORE: int = 100

var good_cat_scene = preload("res://Minigames/cat.tscn")
var bad_cat_scene = preload("res://Minigames/bad_cat.tscn")
var unused_letter_array: Array = ["Q", "W", "E", "S", "A", "D", "Z", "X", "C", "R", "F", "V"]
var used_letter_array: Array
var total_score: int = 0

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	score_progress_bar.max_value = WINNING_SCORE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if total_score >= WINNING_SCORE:
		print("WE WON")
	
	timer_label.text = str(int(game_timer.time_left))

func _unhandled_input(event):
	for letter in used_letter_array:
		if letter == event.as_text():
			LetterPressed.emit(letter)
			

func get_rand_spawn_coordinates() -> Vector2:
	return Vector2(rng.randf_range(145, 550 ), rng.randf_range(200, 400))


func assign_letter() -> String:
	var random_letter = unused_letter_array.pick_random()
	#in case array is empty, random letter will be NULL
	if random_letter:
		#remove from unused letter array
		unused_letter_array.erase(random_letter)
		#add to used letter array to use for input detection
		used_letter_array.append(random_letter)
		return random_letter
	else:
		print("All letters are in use")
		return ""
		

func spawn_cat():
	var cat_instance
	#decide to spawn good cat or bad cat. Biased towards good cat
	var rand_number = rng.randf_range(0, 1) 
	if rand_number > 0.7:
		cat_instance = good_cat_scene.instantiate()
	else:
		cat_instance = bad_cat_scene.instantiate()

	#Assign letter to cat instance
	cat_instance.assigned_letter = assign_letter()
	#print("This is the letter ", cat_instance.assigned_letter)
	#If assigned letter is not empty, aka array wasn't empty
	if cat_instance.assigned_letter:
		#add to correct parent
		cats_container.add_child(cat_instance)

		#connect the signal CatDespawned from the cat to our  append function
		cat_instance.connect("CatDespawned", _consume_letter)
		
		# connect our signal LetterPressed to the cat instance's letter pressed function
		LetterPressed.connect(Callable(cat_instance, "_on_assigned_letter_pressed"))
		
		#get spawn coordinates
		var spawn_location: Vector2 = get_rand_spawn_coordinates()
		#spawn after assigning letter so label is correct
		cat_instance.spawn(spawn_location)
		
	else: #If array is empty aka max simultanous cat spawns reached, delete cat
		cat_instance.queue_free()
	
func _consume_letter(letter: String, score: int):
	unused_letter_array.append(letter)
	#print(unused_letter_array)
	used_letter_array.erase(letter)
	total_score += score
	total_score = clamp(total_score, 0, WINNING_SCORE)
	print("Score is now: ", total_score)
	#update score on label
	score_progress_bar.value = total_score

func _on_timer_timeout():
	spawn_cat()
	spawn_cat()
	spawn_cat()
	spawn_cat()
	spawn_cat()
	spawn_cat()
	spawn_cat()
	spawn_cat()


func _on_game_timer_timeout():
	print("Time Out!")
