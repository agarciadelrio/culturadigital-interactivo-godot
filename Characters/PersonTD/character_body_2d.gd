extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 128.0
var last_direction = "down"

func _ready() -> void:
	add_to_group("player")
	animated_sprite_2d.play("idle_down")

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("left","right","up","down")
	
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation('idle')
		last_direction = 'down'
		return
		
	if abs(input_direction.x) > abs(input_direction.y):
		if input_direction.x < 0:
			last_direction = 'left'
		else:
			last_direction = 'right'
	else:
		if input_direction.y < 0:
			last_direction = "up"
		else:
			last_direction = "down"		
	update_animation('walk')
	velocity = input_direction * speed

func update_animation(state) -> void:
	if state=='idle' and last_direction != "down":
		last_direction = "down"
	animated_sprite_2d.play(state + '_' + last_direction)
