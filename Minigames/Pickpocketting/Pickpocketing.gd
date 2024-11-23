extends Node2D

signal PickpocketGameWon

#Background
@onready var background_image = $BackgroundImage

#@onready var displace_timer = $DisplaceTimer
@onready var tracing_area = $TracingArea
@onready var keep_out_area = $KeepOutArea
@onready var grace_area = $TracingArea/GraceArea

# Game logic
@onready var starting_position = $StartingPosition
@onready var game_start_timer = $GameStartTimer
@onready var shake_screen_timer = $ShakeScreenTimer
@onready var transition_timer = $TransitionTimer
@onready var info_label = $TracingArea/Path2D/InfoLabel
@onready var countdown_text = $TracingArea/StartingArea/CountdownText

#player and lives
@onready var player = $Player
@onready var lives = $Player/Lives

#Audio
@onready var hit_audio = $HitAudio


#Camera stuff
@onready var path_follow_2d = $TracingArea/Path2D/PathFollow2D
@onready var camera_2d = $TracingArea/Path2D/PathFollow2D/Camera2D

#Obstacles
@onready var obstacle_spawn_positions = $TracingArea/Path2D/PathFollow2D/ObstacleSpawnPositions

const PICKPOCKETING_TUTORIAL_MENU = preload("res://Minigames/Pickpocketting/pickpocketing_tutorial_menu.tscn")
const OBSTACLE_SCENE = preload("res://Minigames/Pickpocketting/pickpocket_obstacle.tscn")
const BLUE = Color(0, 0, 1, 0.5)
const RED = Color(1, 0, 0, 0.5)
const YELLOW = Color(0, 1, 1, 0.5)
const YOU_LOST: String = "You Lost"
const CAMERA_SPEED: float = 30

var game_started: bool = false
#var last_known_player_position: Vector2 = Vector2.ZERO
var tries_left: int = 5
var shake_screen: bool = false
var shake_screen_strength: float = 15
var shake_fade: float = 5
var is_hit: bool = false
var rng = RandomNumberGenerator.new()


func _ready():
	PickpocketGameWon.connect(AllKnowing._on_pickpocket_won)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#idk what this offset is but if i don't put it in the position of the player is not correct
	player.position = get_local_mouse_position()# - Vector2(6, 6)
	
	#skew_background(delta)
	
	if game_started:
		#idk what this offset is but if i don't put it in the position of the player is not correct
		#player.position = get_local_mouse_position() - Vector2(6, 6)
		path_follow_2d.progress += CAMERA_SPEED * delta
		#info_label.look_at(player)
	
	if !game_start_timer.is_stopped():
		countdown_text.text = str(int(game_start_timer.time_left))
	
	if is_hit:
		var collision_array = keep_out_area.get_overlapping_areas()
		if collision_array.size() > 0:
			game_started = false
			
		else:
			if shake_screen_timer.is_stopped():
				is_hit = false
				recover()
			#for collider in collision_array:
				
	#if displace: 
		#displace_area()
	#
	#if displace_vertical:
		#displace_area_vertical()
	
	if shake_screen:
		screen_shake(delta)

func screen_shake(delta):
	shake_screen_strength = lerpf(shake_screen_strength, 0, shake_fade * delta)
	camera_2d.offset = Vector2.ONE * rng.randf_range(-shake_screen_strength, shake_screen_strength)

func edit_info_label(text: String, color: Color):
	info_label.text = text
	info_label.push_color(color)

func reset():
	game_started = false
	player.global_position = starting_position.global_position
	camera_2d.global_position = starting_position.global_position
	game_start_timer.start()

func start_game():
	print("Now we start the game")
	game_started = true

func spawn_obstacle():
	if !game_started:
		return
	var obstacle_instance = OBSTACLE_SCENE.instantiate()
	obstacle_instance.player_node = player
	add_child(obstacle_instance)
	obstacle_instance.spawn(choose_spawn_position())

func choose_spawn_position() -> Vector2:
	#choose a random spawn location 
	var spawn_position_array = obstacle_spawn_positions.get_children()
	var chosen_spot = rng.randf_range(0, spawn_position_array.size())
	return spawn_position_array[chosen_spot].global_position

func hit():
	#to prevent multiple calls of the method at once, return if a call has been made before the full hit -> shake -> timer -> recover cycle ends
	if is_hit:
		return
	is_hit = true
	game_started = false
	hit_audio.play()
	lose_life()
	
	#activate shake screen
	shake_screen = true
	shake_screen_timer.start()
	
	

func lose_life():
	#subtract remaining tries and check for game lost 
	tries_left -= 1
	lives.get_child(tries_left).visible = false
	if tries_left <= 0:
		game_lost()
	

func recover():
	#player.global_position = camera_2d.global_position
	shake_screen = false
	game_started = true
	shake_screen_strength = 15

func game_lost():
	game_started = false
	#transition_timer.start()
	#await transition_timer.timeout
	get_tree().change_scene_to_packed(PICKPOCKETING_TUTORIAL_MENU)
	edit_info_label(YOU_LOST, RED)

func game_won():
	game_started = false
	transition_timer.start()
	await transition_timer.timeout
	PickpocketGameWon.emit()
	print("You win!")

#func skew_background(delta):
	#if background_image.skew >= 2:
		#background_image.skew -= lerp(2, 0, 0.2*delta)
	#else:
		#background_image.skew -= lerp(0, -2, 0.2*delta)


func _on_starting_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		reset()

func _on_game_start_timer_timeout():
	start_game()

func _on_spawn_timer_timeout():
	spawn_obstacle()

func _on_tracing_area_mouse_exited():
	if !game_started:
		return

	#edit_info_label("Be Careful!", BLUE)

func _on_grace_area_mouse_exited():
	if !game_started:
		return
	hit()

func _on_win_area_mouse_entered():
	if !game_started:
		return
	game_won()












