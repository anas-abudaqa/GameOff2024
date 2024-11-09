extends Node2D

signal PickpocketGameWon

@onready var displace_timer = $DisplaceTimer
@onready var camera_2d = $Camera2D
@onready var tracing_area = $TracingArea
@onready var grace_area = $TracingArea/GraceArea
@onready var shake_screen_timer = $ShakeScreenTimer
@onready var start_label = $TracingArea/StartingArea/StartLabel
@onready var info_label = $InfoLabel

const BLUE = Color(0, 0, 1, 0.5)
const RED = Color(1, 0, 0, 0.5)
const YELLOW = Color(0, 1, 1, 0.5)
const YOU_LOST: String = "You Lost"

var start_game: bool = false

var displace_offset: float = 15
var displace: bool = false
var displace_vertical: bool = false

var tries_left: int = 3
var shake_screen: bool = false
var shake_screen_strength: float = 30
var shake_fade: float = 5
var rng = RandomNumberGenerator.new()
var cool_down: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tries_left <= 0:
		edit_info_label(YOU_LOST, RED)
	
	if displace: 
		displace_area()
	
	if displace_vertical:
		displace_area_vertical()
	
	if shake_screen:
		screen_shake(delta)
		
func screen_shake(delta):
	shake_screen_strength = lerpf(shake_screen_strength, 0, shake_fade * delta)
	camera_2d.offset = Vector2.ONE * rng.randf_range(-shake_screen_strength, shake_screen_strength)

	

func displace_area():
	if displace_offset > -15:
		var tween = create_tween()
		tween.tween_property(tracing_area, "global_position", global_position + Vector2(displace_offset, 0), 1)
		await tween.finished
		displace_offset -= 1
	else:
		return

func displace_area_vertical():
	if displace_offset > -15:
		var tween = create_tween()
		tween.tween_property(tracing_area, "global_position", global_position + Vector2(0, displace_offset), 1)
		await tween.finished
		displace_offset -= 1
	else:
		return

func edit_info_label(text: String, color: Color):
	info_label.text = text
	info_label.push_color(color)
	

func _on_starting_area_mouse_exited():
	print("Now we start the game")
	start_game = true
	start_label.visible = false

func _on_tracing_area_mouse_entered():
	if !start_game:
		return
	edit_info_label("Be Sneaky!", BLUE)


func _on_tracing_area_mouse_exited():
	if !start_game:
		return

	edit_info_label("Be Careful!", BLUE)

func _on_grace_area_mouse_exited():
	if !start_game:
		return
		
	tries_left -= 1
	shake_screen = true
	start_game = false
	edit_info_label(str(tries_left), RED)
	shake_screen_timer.start()

func _on_win_area_mouse_entered():
	if !start_game:
		return
	PickpocketGameWon.emit()
	print("You win!")


func _on_displace_area_mouse_entered():
	if !start_game:
		return

	if not displace:
		displace = true
		displace_offset = 10
		displace_timer.start()

func _on_displace_area_2_mouse_entered():
	if !start_game:
		return

	if not displace_vertical:
		displace_vertical = true
		displace_offset = 10
		displace_timer.start()

func _on_shake_timer_timeout():
	displace = false
	displace_vertical = false

func _on_shake_screen_timer_timeout():
	shake_screen = false
	start_game = true
	shake_screen_strength = 30










