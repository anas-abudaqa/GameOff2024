extends Node2D

signal LetterPressed(letter: String)

var good_cat_scene = preload("res://Minigames/cat.tscn")
var bad_cat_scene = preload("res://Minigames/bad_cat.tscn")
var unused_letter_array: Array = ["Q", "W", "E", "S", "A", "D", "Z", "X", "C"]
var used_letter_array: Array
var total_score: int = 0

var rng = RandomNumberGenerator.new()
@onready var cats_container = $CatsContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	spawn_cat()

func _unhandled_input(event):
	for letter in used_letter_array:
		if letter == event.as_text():
			print("We have a match!")
			LetterPressed.emit(letter)
			

func get_rand_spawn_coordinates() -> Vector2:
	return Vector2(rng.randf_range(150, 500 ), rng.randf_range(100, 550))

func assign_letter() -> Variant:
	var random_letter = unused_letter_array.pick_random()
	#in case array is empty, random letter will be NULL
	if random_letter:
		#remove from unused letter array
		unused_letter_array.erase(random_letter)
		#add to used letter array to use for input detection
		used_letter_array.append(random_letter)
		return random_letter
	else:
		return
		

func spawn_cat():
	var cat_instance
	#decide to spawn good cat or bad cat. Biased towards good cat
	var rand_number = rng.randf_range(0, 1) 
	if rand_number > 0.4:
		cat_instance = good_cat_scene.instantiate()
	else:
		cat_instance = bad_cat_scene.instantiate()

	#Assign letter to cat instance
	cat_instance.assigned_letter = assign_letter()
	#If assigned letter is not null, aka array wasn't empty
	if cat_instance.assigned_letter:
		#add to correct parent
		cats_container.add_child(cat_instance)
		
		#connect signal CatDespawned
		cat_instance.connect("CatDespawned", "_append_consumed_letter")
		#connect signal LetterPressed
		cat_instance.connect("LetterPressed", cat_instance, "_on_assigned_letter_pressed")
		
		#get spawn coordinates
		var spawn_location: Vector2 = get_rand_spawn_coordinates()
		#spawn after assigning letter so label is correct
		cat_instance.spawn(spawn_location)
		
	else: #If array is empty aka max simultanous cat spawns reached, delete cat
		cat_instance.queue_free()
	
func _append_consumed_letter(letter: String, score: int):
	unused_letter_array.append(letter)
	total_score = score
