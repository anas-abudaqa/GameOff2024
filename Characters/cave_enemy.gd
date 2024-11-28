extends Area2D

signal PlayerDetected

@export var movement_direction: String
@export var can_move: bool = true
@export var can_rotate: bool = false
@export var rotation_speed: float = 0.5
@export var movement_speed: int = 90


@onready var left_cone = $DetectionArea/LeftCone
@onready var right_cone = $DetectionArea/RightCone
@onready var down_cone = $DetectionArea/DownCone
@onready var up_cone = $DetectionArea/UpCone
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var detection_area = $DetectionArea


var direction_vector = Vector2.ZERO
var rotation_direction: String = "CW"

func _ready():
	detection_area.modulate = Color(1,1,1)
	turn_off_cones()
	change_direction()

func _physics_process(delta):
	if can_move:
		translate(movement_speed * direction_vector * delta)
	else:
		animated_sprite_2d.stop()
	
	if can_rotate:
		rotate_sprite()

func rotate_sprite():
	if rotation_direction == "CW":
			rotation_degrees += rotation_speed
			if rotation_degrees > 45:
				rotation_direction = "ACW"
	else:
		rotation_degrees -= rotation_speed
		if rotation_degrees <= 0:
			rotation_direction = "CW"

func change_direction():
	match(movement_direction):
		"Up":
			turn_off_cones()
			up_cone.visible = true
			up_cone.set_deferred("disabled", false)
			animated_sprite_2d.play("Up")
			direction_vector = Vector2.UP
		"Down":
			turn_off_cones()
			down_cone.visible = true
			down_cone.set_deferred("disabled", false)
			animated_sprite_2d.play("Down")
			direction_vector = Vector2.DOWN
		"Right": 
			turn_off_cones()
			right_cone.visible = true
			right_cone.set_deferred("disabled", false)
			animated_sprite_2d.play("Right")
			direction_vector = Vector2.RIGHT
		"Left":
			turn_off_cones()
			left_cone.visible = true
			left_cone.set_deferred("disabled", false)
			animated_sprite_2d.play("Left")
			direction_vector = Vector2.LEFT

func turn_off_cones():
	left_cone.visible = false
	left_cone.set_deferred("disabled", true)
	right_cone.visible = false
	right_cone.set_deferred("disabled", true)
	up_cone.visible = false
	up_cone.set_deferred("disabled", true)
	down_cone.visible = false
	down_cone.set_deferred("disabled", true)



func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		print("bomboclaat")
		detection_area.modulate = Color(1, 0, 0, 73)
		PlayerDetected.emit()


func _on_detection_area_body_exited(body):
	detection_area.modulate = Color(1, 1, 1, 1)
