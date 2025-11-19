extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var root_node = get_parent().get_parent()

var last_direction = "down"

func _ready() -> void:
	add_to_group("player")
	animated_sprite_2d.play("idle_down")

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()


func get_input():
	# Solo usar input del eje X (left y right)
	var input_direction_x = Input.get_axis("left", "right")
	
	# CORRECCIÓN: Usar abs() < 0.1 en lugar de == 0 para floats
	if abs(input_direction_x) < 0.1:
		velocity = Vector2.ZERO
		last_direction = 'down'
		update_animation('idle')
		return
	
	# Movimiento solo en X
	velocity = Vector2(input_direction_x, 0) * root_node.speed
	
	# Determinar dirección
	if input_direction_x < 0:
		last_direction = 'left'
	else:
		last_direction = 'right'
	
	update_animation('walk')

func update_animation(state) -> void:
	animated_sprite_2d.play(state + '_' + last_direction)
