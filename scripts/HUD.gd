extends Control

var max_health = 3
var current_health = 3
var max_ammo = 10
var current_ammo = 10
var coins = 0
var kills = 0
var is_reloading = false

func _ready():
	$ReloadTimer.timeout.connect(_on_reload_timer_timeout)

func update_health(new_health):
	current_health = new_health
	for i in range(3):
		var heart = get_node("MarginContainer/Stats/Health/Heart" + str(i + 1))
		heart.text = "❤️" if i < current_health else "🖤"

func update_ammo(new_ammo):
	current_ammo = new_ammo
	$MarginContainer/Stats/Ammo.text = "🔫 " + str(current_ammo) + "/" + str(max_ammo)

func update_coins(new_coins):
	coins = new_coins
	$MarginContainer/Stats/Coins.text = "🪙 " + str(coins)

func update_kills(new_kills):
	kills = new_kills
	$MarginContainer/Stats/Kills.text = "☠️ " + str(kills)

func start_reload():
	if not is_reloading and current_ammo < max_ammo:
		is_reloading = true
		$ReloadingLabel.show()
		$ReloadTimer.start()

func _on_reload_timer_timeout():
	is_reloading = false
	current_ammo = max_ammo
	update_ammo(current_ammo)
	$ReloadingLabel.hide()

func can_shoot():
	return current_ammo > 0 and not is_reloading 