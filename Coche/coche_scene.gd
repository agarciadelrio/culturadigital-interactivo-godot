class_name CocheScene extends Node2D

@export var max_speed: float = 360.0
@export var acceleration_time: float = 3.0
@export var go_left: bool = false

@onready var driver: AnimatedSprite2D = $Driver
@onready var wheel_front: Sprite2D = $RuedaF
@onready var wheel_rear: Sprite2D = $RuedaR

var current_angular_speed: float = 0.0
var is_driver_inside : bool = false

func _ready() -> void:
	driver.play("idle")
	#start_wheel_animation()
	
func _process(delta):
	var right_pressed = Input.is_action_pressed("right")
	var left_pressed = Input.is_action_pressed("left")
	
	if is_driver_inside and right_pressed and not left_pressed:
		#current_speed = move_toward(current_speed, MAX_FORWARD_SPEED, ACCELERATION * delta)		
		current_angular_speed = 400
	elif is_driver_inside and left_pressed and not right_pressed:
		current_angular_speed = -400
	else:
		current_angular_speed = 0
		
	if abs(current_angular_speed) > 0.01:
		var rot = current_angular_speed * delta
		wheel_front.rotation_degrees += rot
		wheel_rear.rotation_degrees += rot
		
func set_driver_inside():
	is_driver_inside = true
	
func set_driver_outside():
	is_driver_inside = false
	
func start_wheel_animation():
	current_angular_speed = 400
	#var target_speed = max_speed if go_left else -max_speed
	#var wheel_tween = create_tween()
	#wheel_tween.tween_method(_set_angular_speed, 0.0, target_speed, acceleration_time)\
	#	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _set_angular_speed(speed: float):
	current_angular_speed = speed
