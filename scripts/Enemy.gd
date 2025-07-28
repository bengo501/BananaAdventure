extends CharacterBody2D

const SPEED = 150.0
const PATROL_DISTANCE = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var start_position
var direction = 1
var player_detected = false
var player = null

func _ready():
	start_position = position

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_detected and player:
		# Move towards player
		var player_direction = (player.position - position).normalized()
		velocity.x = player_direction.x * SPEED
	else:
		# Patrol behavior
		if abs(position.x - start_position.x) > PATROL_DISTANCE:
			direction *= -1
		velocity.x = direction * SPEED
	
	# Update sprite direction
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player_detected = true
		player = body

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_detected = false
		player = null 