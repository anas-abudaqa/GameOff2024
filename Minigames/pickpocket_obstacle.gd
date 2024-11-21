extends CharacterBody2D

@onready var expiry_timer = $ExpiryTimer
@export var player_node: CharacterBody2D

var rng = RandomNumberGenerator.new()

var target_position: Vector2 = Vector2.ZERO
var target_speed: float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = global_position.direction_to(target_position) * target_speed * delta


func spawn(spawn_position: Vector2):
	global_position = spawn_position
	if player_node:
		target_position = player_node.global_position
	
	target_speed = rng.randf_range(200,400)
	#target_speed += Vector2(rng.randf_range(-25, -75), rng.randf_range(0, -50))
	expiry_timer.start()


func _on_expiry_timer_timeout():
	queue_free()
