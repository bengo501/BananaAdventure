extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500.0
const FRICTION = 1000.0
const RELOAD_LABEL = preload("res://scenes/ReloadLabel.tscn")

# Coyote time and jump buffer variables
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var was_on_floor = false
var health = 3
var coins = 0
var kills = 0
var reload_label = null

func _ready():
	# Initialize HUD
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_health(health)
		hud.update_coins(coins)
		hud.update_kills(kills)
		
	# Criar e configurar a label de reload
	reload_label = RELOAD_LABEL.instantiate()
	add_child(reload_label)
	reload_label.hide()
	
	# Conectar sinais da arma
	var weapon = $WeaponHolder/Weapon
	if weapon:
		weapon.reload_started.connect(_on_reload_started)
		weapon.reload_completed.connect(_on_reload_completed)
		weapon.reload_progress.connect(_on_reload_progress)

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Coyote time logic
	if was_on_floor and not is_on_floor():
		coyote_timer = COYOTE_TIME
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		
	# Jump buffer logic
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	# Handle Jump with coyote time and jump buffer
	if (jump_buffer_timer > 0 and coyote_timer > 0) or (Input.is_action_just_pressed("jump") and coyote_timer > 0):
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0

	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		# Apply acceleration
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		# Apply friction
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	was_on_floor = is_on_floor()
	move_and_slide()

	# Flip sprite based on movement direction
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true
		
	# Check for death conditions
	if position.y > 1000:  # Fell off the map
		die()
		
	# Handle reload input
	if Input.is_action_just_pressed("reload"):
		var weapon = $WeaponHolder/Weapon
		if weapon:
			weapon.start_reload()

func _on_reload_started():
	if reload_label:
		reload_label.show()
		print("Player: Mostrando label de reload")

func _on_reload_completed():
	if reload_label:
		reload_label.hide()
		print("Player: Escondendo label de reload")

func _on_reload_progress(percent):
	if reload_label:
		reload_label.get_node("Label").text = "Recarregando... " + str(percent) + "%"
		print("Player: Atualizando progresso do reload: ", percent, "%")

func take_damage():
	health -= 1
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_health(health)
	if health <= 0:
		die()

func collect_coin():
	coins += 1
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_coins(coins)

func add_kill():
	kills += 1
	var hud = get_node("/root/Main/UI/HUD")
	if hud:
		hud.update_kills(kills)
		
func die():
	# Get the game over screen and show it
	var game_over = get_node("/root/Main/UI/GameOver")
	if game_over:
		game_over.show_game_over()

func _on_hit_by_enemy():
	take_damage() 
