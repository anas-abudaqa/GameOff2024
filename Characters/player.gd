extends CharacterBody2D


@onready var interactable_detector = $InteractableDetector

const SPEED = 100.0

var direction_vector = Vector2.ZERO

func _physics_process(delta):

	if Input.is_action_just_pressed("Interact"):
		print("Checking for interactables")
		var detected_interactables = interactable_detector.get_overlapping_areas()
		if detected_interactables.size() > 0:
			#for each interactable found
			for interactable_child in detected_interactables:
				#the parents have the interact function, not the interactable area2D itself
				interactable_child.get_parent().interact()
				
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
	

	move_and_slide()
