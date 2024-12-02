extends CharacterBody2D


@onready var interactable_detector = $InteractableDetector

const SPEED = 100.0

var direction_vector = Vector2.ZERO
var rotation_direction: String = "CW"
var max_angle: int
var rotation_speed: int = 30

func _physics_process(delta):

	if Input.is_action_just_pressed("Interact"):
		print("Checking for interactables")
		var detected_interactables = interactable_detector.get_overlapping_areas()
		if detected_interactables.size() > 0:
			#for each interactable found
			for interactable_child in detected_interactables:
				#the parents have the interact function, not the interactable area2D itself
				interactable_child.get_parent().interact()
	
	#if Input.is_action_just_pressed("Debug"):
		##AllKnowing.has_heart = true
		##Dialogic.start("Obtained_Heart")
		#AllKnowing.obtained_undeadheart = true
		#AllKnowing.obtained_brainjar7 = true
		#AllKnowing.obtained_damnedtongue = true
		#AllKnowing.obtained_sacrificeblood= true
		
#-x, +x, -y, +y
	direction_vector = Input.get_vector("Left", "Right", "Up", "Down")
	if direction_vector.x:
		velocity.x = direction_vector.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction_vector.y:
		velocity.y = direction_vector.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if direction_vector:
		movement_animation(delta)
	else:
		rotation_degrees = 0
	move_and_slide()

func movement_animation(delta):
	if rotation_direction == "CW":
		rotation_degrees += rotation_speed * delta
		if rotation_degrees >= 5:
			rotation_direction = "ACW"
			
	elif rotation_direction == "ACW":
		rotation_degrees -= rotation_speed * delta
		if rotation_degrees <= -5:
			rotation_direction = "CW"
			
