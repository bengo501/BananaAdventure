extends Node2D

const BULLET_SPEED = 600
const BULLET_SCENE = preload("res://scenes/Bullet.tscn")

signal reload_started
signal reload_completed
signal reload_progress(percent)

var is_reloading = false
var reload_timer = 0.0
const RELOAD_TIME = 1.0  # Reduzido para 1 segundo para testes

func _ready():
	print("Arma inicializada")

func _physics_process(delta):
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
		start_reload()
		
	# Atualizar timer de reload
	if is_reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			complete_reload()
		else:
			update_reload_progress()

func shoot():
	if is_reloading:
		print("Não pode atirar durante o reload!")
		return
		
	var hud = get_node("/root/Main/UI/HUD")
	if hud and hud.current_ammo > 0:
		print("Atirando - Munição restante: ", hud.current_ammo - 1)
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = $BulletSpawn.global_position
		bullet.rotation = rotation
		bullet.velocity = Vector2.RIGHT.rotated(rotation) * BULLET_SPEED
		get_tree().current_scene.add_child(bullet)
		hud.update_ammo(hud.current_ammo - 1)
	else:
		print("Sem munição!")

func start_reload():
	var hud = get_node("/root/Main/UI/HUD")
	if hud and not is_reloading and hud.current_ammo < hud.max_ammo:
		print("Iniciando reload...")
		is_reloading = true
		reload_timer = RELOAD_TIME
		emit_signal("reload_started")
		update_reload_progress()

func complete_reload():
	print("Reload completo!")
	is_reloading = false
	reload_timer = 0.0
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_ammo(hud.max_ammo)
	emit_signal("reload_completed")

func update_reload_progress():
	var percent = int((1.0 - (reload_timer / RELOAD_TIME)) * 100)
	print("Progresso do reload: ", percent, "%")
	emit_signal("reload_progress", percent) 
