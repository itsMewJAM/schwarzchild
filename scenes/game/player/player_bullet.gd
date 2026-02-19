extends Area2D

@export var speed : float

func _physics_process(delta):
	position += transform.x * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
