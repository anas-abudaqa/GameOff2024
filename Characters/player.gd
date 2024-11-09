extends Area2D

#@export var tile_map: TileMap
@onready var collision_ray_cast_2d = $CollisionRayCast2D

var tile_size = 16
var direction: Vector2 = Vector2.ZERO
var hold_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false


func _process(_delta):
	if !is_moving and hold_direction:
		move(hold_direction)

func _unhandled_input(event):

	if event.is_action_pressed("Down"):
		direction = Vector2.DOWN
		hold_direction = Vector2.DOWN
		move(direction)
	if event.is_action_pressed("Up"):
		direction = Vector2.UP
		hold_direction = Vector2.UP
		move(direction)
	if event.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		hold_direction = Vector2.RIGHT 
		move(direction)
	if event.is_action_pressed("Left"):
		direction = Vector2.LEFT
		hold_direction = Vector2.LEFT
		move(direction)
	
	if event.is_action_released("Down"):
		hold_direction = Vector2.ZERO
	if event.is_action_released("Up"):
		hold_direction = Vector2.ZERO
	if event.is_action_released("Right"):
		hold_direction = Vector2.ZERO
	if event.is_action_released("Left"):
		hold_direction = Vector2.ZERO
	
	#print(keep_going)
func move(target_direction: Vector2):
	collision_ray_cast_2d.target_position = target_direction * tile_size
	collision_ray_cast_2d.force_raycast_update()
	if !collision_ray_cast_2d.is_colliding():
		if !is_moving:
			var tween = create_tween()
			tween.tween_property(self, "global_position", global_position + target_direction * tile_size, 0.3)
			is_moving = true
			await tween.finished
			is_moving = false
	
	
	#print(is_moving)
	#global_position += target_direction * tile_size
	#direction = Vector2.ZERO
	#get current tile
	#var current_tile_coordinates: Vector2i = tile_map.local_to_map(global_position)
	##get target tile
	#var target_tile_coordinates: Vector2i = Vector2i(
		#current_tile_coordinates.x + direction.x,
		#current_tile_coordinates.y + direction.y
	#)
	##check if walkable
	#var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile_coordinates)
	#if !tile_data.get_custom_data("Walkable"):
		#print("We can't walk there")
		##move player
		#return
	
	#print(direction, current_tile_coordinates, target_tile_coordinates)
	
	#global_position = tile_map.map_to_local(target_tile_coordinates)
