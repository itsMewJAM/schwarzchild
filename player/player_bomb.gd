extends Area2D

@onready var bomb_lifespan : int = 60

var bomb_life : int

func _ready() -> void:
	bomb_life = bomb_lifespan
	
func _physics_process(delta: float) -> void:
	if bomb_life < 1:
		queue_free()
	else:
		bomb_life -= 1
