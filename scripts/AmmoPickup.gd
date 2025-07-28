extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		var hud = get_node("/root/Main/UI/HUD")
		if hud:
			hud.update_ammo(hud.max_ammo)
		queue_free() 