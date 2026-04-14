extends CharacterBody2D

@export var focused_speed : float
@export var unfocused_speed : float
@export var fire_rate : int
var fire_cooldown : int = 0
@export var bomb_radius : int = 100
@export var radius_color : Color
@export var charge_color : Color
@export var radius_line_rotation : float
@export var charge_amount : int # Factor of bomb_radius\
@export var bomb_charge_lower_bound : int
var bomb_charge : float = 0
var radius_line : Vector2

@export var Bullet : PackedScene
@export var Bomb : PackedScene

@onready var hitbox = $Hitbox
var input_dir = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radius_line = Vector2(bomb_radius - 0.5, 0)
	pass

# Called once every 60 seconds, ideally...
func _physics_process(delta: float) -> void:
	input_dir.x = Input.get_action_strength("game_right") - Input.get_action_strength("game_left")
	input_dir.y = Input.get_action_strength("game_down") - Input.get_action_strength("game_up") 
	
	# Move
	move(input_dir)
	
	# Toggle whether hitbox is active every frame
	hitbox.disabled = !hitbox.disabled
	
	# Check intent for shot and shoot if cooldown allows
	if Input.is_action_pressed("game_button3"):
		if fire_cooldown == 0:
			shoot()
			fire_cooldown = fire_rate
			
	# Update shot cooldown
	if fire_cooldown > 0:
		fire_cooldown -= 1
		
	
	# Check intent for bomb charge
	if Input.is_action_pressed("game_button2"):
		bomb_charge = charge_bomb(bomb_charge)
	else:
		if bomb_charge > bomb_charge_lower_bound:
			bomb()
		bomb_charge = 0
		
	#radius_line = Vector2(cos(radius_line_rotation * radius_line.x) - sin(radius_line_rotation * radius_line.y), sin(radius_line_rotation * radius_line.x) + cos(radius_line_rotation * radius_line.y))
	radius_line = radius_line.rotated(radius_line_rotation)
	print(radius_line)
		
	queue_redraw()
	# print(bomb_charge)

func move(dir):
	velocity = dir
	
	# Normalize
	velocity = velocity.normalized()
	
	velocity *= unfocused_speed
	
	move_and_collide(velocity)
	# print(velocity)
	

func charge_bomb(cur_charge):
	if cur_charge < bomb_radius:
		cur_charge += charge_amount
	# print("Bombin!", cur_charge)
	return cur_charge
	
func bomb():
	var bomb = Bomb.instantiate()
	bomb.transform = global_transform
	bomb.transform.x = Vector2(float(bomb_charge) / bomb_radius, 0)
	bomb.transform.y = Vector2(0, float(bomb_charge) / bomb_radius)
	owner.add_child(bomb)
	
	
func _draw():
	print(bomb_charge)
	draw_circle(Vector2.ZERO, bomb_radius, radius_color, false, 2.0)
	draw_line(-radius_line, radius_line, radius_color, 1.0)
	draw_circle(Vector2.ZERO, bomb_charge, charge_color, false, 2.0)

func shoot():
	var b1 = Bullet.instantiate()
	owner.add_child(b1)
	b1.transform = $FrontSpawner.global_transform
	
	var b2 = Bullet.instantiate()
	owner.add_child(b2)
	b2.transform = $LeftSpawner.global_transform
	
	var b3 = Bullet.instantiate()
	owner.add_child(b3)
	b3.transform = $RightSpawner.global_transform
	
