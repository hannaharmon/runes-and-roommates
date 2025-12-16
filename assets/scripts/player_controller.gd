extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 10.0

var direction = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_power

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		if velocity.x > 0:
			%Sprite2D.scale.x = 1
		if velocity.x < 0:
			%Sprite2D.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
