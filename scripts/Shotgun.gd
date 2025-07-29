extends "res://scripts/BaseWeapon.gd"

func _ready():
	weapon_name = "Shotgun"
	max_ammo = 6
	reload_time = 1.5
	bullet_speed = 500
	spread_angle = 60
	bullets_per_shot = 5
	current_ammo = max_ammo
	
	$AnimatedSprite2D.play("idle")

func play_shoot_animation():
	$AnimatedSprite2D.play("shoot")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")

func play_reload_animation():
	$AnimatedSprite2D.play("reload")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")

func handle_rotation():
	# Get the direction to the mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Calculate the angle to the mouse
	rotation = direction.angle()
	
	# Flip the sprite if aiming left
	if abs(rotation_degrees) > 90:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false 