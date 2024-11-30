extends Node2D


@export var enemy_to_connect: Area2D
@export var starting_direction: String
@onready var line_2d = $Line2D
@onready var stop_timer = $StopTimer
@onready var cooldown_timer = $CooldownTimer


var on_cooldown: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	##line2d add point works only with local coordinates, so we need to convert 
	line_2d.add_point(to_local(enemy_to_connect.global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	line_2d.set_point_position(1,to_local(enemy_to_connect.global_position))


func interact():
	if !on_cooldown:
		call_enemy()
	else:
		print("Cooldown man")
	
func call_enemy():
	on_cooldown = true
	enemy_to_connect.movement_direction = starting_direction
	enemy_to_connect.change_direction()
	enemy_to_connect.can_rotate = false
	enemy_to_connect.can_move = true

	

func _on_interactable_area_entered(area):
	area.can_move = false
	stop_timer.start()


func _on_stop_timer_timeout():
	enemy_to_connect.can_move = true
	cooldown_timer.start()


func _on_cooldown_timer_timeout():
	on_cooldown = false
