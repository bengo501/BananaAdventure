extends Node2D

const BULLET_SPEED = 600
const BULLET_SCENE = preload("res://scenes/Bullet.tscn")

func _physics_process(_delta):
	# Get the direction to the mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Calculate the angle to the mouse
	rotation = direction.angle()
	
	# Flip the weapon sprite if aiming left
	if abs(rotation_degrees) > 90:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	# Handle reload
	if Input.is_action_just_pressed("reload"):
		var hud = get_node("/root/Main/UI/HUD")
		if hud:
			hud.start_reload()

func shoot():
	var hud = get_node("/root/Main/UI/HUD")
	if hud and hud.can_shoot():
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = $BulletSpawn.global_position
		bullet.rotation = rotation
		bullet.velocity = Vector2.RIGHT.rotated(rotation) * BULLET_SPEED
		# Add bullet to the game world
		get_tree().current_scene.add_child(bullet)
		# Update ammo count
		hud.update_ammo(hud.current_ammo - 1) 