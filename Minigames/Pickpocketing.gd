extends Node2D

signal PickpocketGameWon

const OBSTACLE_SCENE = preload("res://Minigames/pickpocket_obstacle.tscn")

@onready var displace_timer = $DisplaceTimer
@onready var tracing_area = $TracingArea
@onready var grace_area = $TracingArea/GraceArea
@onready var shake_screen_timer = $ShakeScreenTimer
@onready var start_label = $TracingArea/StartingArea/StartLabel
@onready var info_label = $InfoLabel

# Game logic
@onready var starting_position = $StartingPosition
@onready var game_start_timer = $GameStartTimer
@onready var player = $Player


#Camera stuff
@onready var path_follow_2d = $TracingArea/Path2D/PathFollow2D
@onready var camera_2d = $TracingArea/Path2D/PathFollow2D/Camera2D
@onready var marker_2d = $TracingArea/Path2D/PathFollow2D/Marker2D

const BLUE = Color(0, 0, 1, 0.5)
const RED = Color(1, 0, 0, 0.5)
const YELLOW = Color(0, 1, 1, 0.5)
const YOU_LOST: String = "You Lost"
const CAMERA_SPEED: float = 30

var game_started: bool = false

#var displace_offset: float = 15
var displace: bool = false
#var displace_vertical: bool = false

var tries_left: int = 3
var shake_screen: bool = false
var shake_screen_strength: float = 30
var shake_fade: float = 5
var rng = RandomNumberGenerator.new()
var cool_down: bool = false

func _ready():
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_started:
		player.position = get_local_mouse_position() - Vector2(6, 6)
		path_follow_2d.progress += CAMERA_SPEED * delta
		
	
	if tries_left <= 0:
		edit_info_label(YOU_LOST, RED)
	
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
	start_label.visible = true
	player.global_position = starting_position.global_position
	camera_2d.global_position = starting_position.global_position
	game_start_timer.start()

func start_game():
	print("Now we start the game")
	game_started = true
	start_label.visible = false

func spawn_obstacle():
	var obstacle_instance = OBSTACLE_SCENE.instantiate()
	add_child(obstacle_instance)
	obstacle_instance.player_node = player
	obstacle_instance.spawn(marker_2d.global_position)

func _on_game_start_timer_timeout():
	start_game()


func _on_spawn_timer_timeout():
	spawn_obstacle()

func _on_tracing_area_mouse_exited():
	if !game_started:
		return

	edit_info_label("Be Careful!", BLUE)

func _on_grace_area_mouse_exited():
	if !game_started:
		return
		
	tries_left -= 1
	shake_screen = true
	game_started = false
	edit_info_label(str(tries_left), RED)
	shake_screen_timer.start()

func _on_win_area_mouse_entered():
	if !game_started:
		return
	PickpocketGameWon.emit()
	print("You win!")


func _on_shake_screen_timer_timeout():
	shake_screen = false
	game_started = true
	shake_screen_strength = 30


#func displace_area():
	#if displace_offset > -15:
		#var tween = create_tween()
		#tween.tween_property(tracing_area, "global_position", global_position + Vector2(displace_offset, 0), 1)
		#await tween.finished
		#displace_offset -= 1
	#else:
		#return
#
#func displace_area_vertical():
	#if displace_offset > -15:
		#var tween = create_tween()
		#tween.tween_property(tracing_area, "global_position", global_position + Vector2(0, displace_offset), 1)
		#await tween.finished
		#displace_offset -= 1
	#else:
		#return




#func _on_starting_area_mouse_exited():
	##print("Now we start the game")
	##game_started = true
	##start_label.visible = false
	#pass
	#
#func _on_tracing_area_mouse_entered():
	#if !game_started:
		#return
	#edit_info_label("Be Sneaky!", BLUE)


#func _on_displace_area_mouse_entered():
	#if !game_started:
		#return
#
	#if not displace:
		#displace = true
		#displace_offset = 10
		#displace_timer.start()
#
#func _on_displace_area_2_mouse_entered():
	#if !game_started:
		#return
#
	#if not displace_vertical:
		#displace_vertical = true
		#displace_offset = 10
		#displace_timer.start()

#func _on_shake_timer_timeout():
	#displace = false
	#displace_vertical = false






