extends CharacterBody2D

@onready var expiry_timer = $ExpiryTimer

var is_tracking: bool = true
var player_node: Area2D
var rng = RandomNumberGenerator.new()

var target_position: Vector2 = Vector2.ZERO
var target_speed: float = 0
var target_rotation: float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_tracking:
		#if tracking, update player position and velocity to point towards player
		target_position = player_node.global_position
		velocity = global_position.direction_to(target_position) * target_speed
	else:
		#if not, keep current velocity
		velocity = velocity
	rotation_degrees += target_rotation * delta
	move_and_slide()

func spawn(spawn_position: Vector2):
	global_position = spawn_position
	target_speed = rng.randf_range(55,65)
	target_rotation = rng.randf_range(120, 200)
	if player_node:
		target_position = player_node.global_position
	velocity = global_position.direction_to(target_position) * target_speed
	expiry_timer.start()

func _on_tracking_timer_timeout():
	is_tracking = false

func _on_area_2d_area_entered(area):
	#on collision mask 2
	area.get_parent().hit()
	queue_free()

func _on_expiry_timer_timeout():
	queue_free()





