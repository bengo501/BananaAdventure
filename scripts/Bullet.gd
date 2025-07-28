extends Area2D

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()  # Destroy enemy
	queue_free()  # Destroy bullet

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # Clean up bullets that go off screen 
