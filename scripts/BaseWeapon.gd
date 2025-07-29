extends Node2D

const BULLET_SCENE = preload("res://scenes/Bullet.tscn")

signal reload_started
signal reload_completed
signal reload_progress(percent)

# Configurações base que podem ser sobrescritas pelas armas específicas
var weapon_name = "Base Weapon"
var max_ammo = 10
var reload_time = 1.0
var bullet_speed = 600
var spread_angle = 0  # Em graus
var bullets_per_shot = 1

var is_reloading = false
var reload_timer = 0.0
var current_ammo = max_ammo

func _ready():
	print(weapon_name + " inicializada")
	current_ammo = max_ammo

func _physics_process(delta):
	handle_rotation()
	handle_reload_timer(delta)

func handle_rotation():
	# Get the direction to the mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	rotation = direction.angle()
	
	# Flip the sprite if aiming left
	if abs(rotation_degrees) > 90:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false

func handle_reload_timer(delta):
	if is_reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			complete_reload()
		else:
			update_reload_progress()

func shoot():
	if is_reloading:
		print(weapon_name + ": Não pode atirar durante o reload!")
		return
		
	if current_ammo <= 0:
		print(weapon_name + ": Sem munição!")
		return
		
	play_shoot_animation()
	print(weapon_name + ": Atirando - Munição restante: ", current_ammo - 1)
	
	for i in range(bullets_per_shot):
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = $BulletSpawn.global_position
		
		# Calcula o ângulo de dispersão
		var random_spread = randf_range(-spread_angle/2, spread_angle/2)
		var bullet_rotation = rotation + deg_to_rad(random_spread)
		
		bullet.rotation = bullet_rotation
		bullet.velocity = Vector2.RIGHT.rotated(bullet_rotation) * bullet_speed
		get_tree().current_scene.add_child(bullet)
		
	current_ammo -= 1
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_ammo(current_ammo)

func start_reload():
	if is_reloading or current_ammo >= max_ammo:
		return
		
	print(weapon_name + ": Iniciando reload...")
	is_reloading = true
	reload_timer = reload_time
	play_reload_animation()
	emit_signal("reload_started")
	update_reload_progress()

func complete_reload():
	print(weapon_name + ": Reload completo!")
	is_reloading = false
	reload_timer = 0.0
	current_ammo = max_ammo
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_ammo(current_ammo)
	emit_signal("reload_completed")

func update_reload_progress():
	var percent = int((1.0 - (reload_timer / reload_time)) * 100)
	print(weapon_name + ": Progresso do reload: ", percent, "%")
	emit_signal("reload_progress", percent)

# Funções virtuais para serem sobrescritas pelas armas específicas
func play_shoot_animation():
	pass

func play_reload_animation():
	pass 
