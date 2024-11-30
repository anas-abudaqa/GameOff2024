extends Area2D

@export var movement_direction: String
@export var can_move: bool = true
@export var movement_speed: int = 90

@onready var animated_sprite_2d = $AnimatedSprite2D

var initial_direction: String
var direction_vector = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_direction = movement_direction
	change_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		translate(movement_speed * direction_vector * delta)
	else:
		animated_sprite_2d.stop()


func change_direction():
	match(movement_direction):
		"Up":
			animated_sprite_2d.play("Up")
			direction_vector = Vector2.UP
		"Down":
			animated_sprite_2d.play("Down")
			direction_vector = Vector2.DOWN
		"Right": 
			animated_sprite_2d.play("Right")
			direction_vector = Vector2.RIGHT
		"Left":
			animated_sprite_2d.play("Left")
			direction_vector = Vector2.LEFT
		"Stop":
			can_move = false
			movement_direction = initial_direction
			change_direction()
