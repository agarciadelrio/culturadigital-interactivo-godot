# Coche.gd
extends Node2D

@onready var wheel_front: Sprite2D = $WheelFront
@onready var wheel_rear: Sprite2D = $WheelRear
@onready var chasis: Node2D = $Ibiza  # O el nodo que contiene el coche (puede ser el root si no hay contenedor)
@onready var exhaust_smoke: GPUParticles2D = $ExhaustSmoke


@export var max_speed: float = 360.0
@export var acceleration_time: float = 3.0
@export var go_left: bool = false

# --- EFECTO ACELERÓN (rotación chasis) ---
@export var lift_angle: float = 3.0      # Grados que se levanta delante
@export var lift_duration: float = 1.8   # Tiempo para volver a 0

# --- SUSPENSIÓN ALEATORIA ---
@export var suspension_amplitude: float = 6.0   # Píxeles arriba/abajo altura del salto
@export var suspension_frequency: float = 10.0   # Oscilaciones por segundo, más baches
@export var suspension_start_delay: float = 1.2 # Casi a la mitad de aceleración

var current_angular_speed: float = 0.0
var suspension_tween: Tween = null
var is_suspension_active: bool = false

# === INICIO ===
func _ready():
	start_wheel_animation()

# === ANIMACIÓN PRINCIPAL ===
func start_wheel_animation():
	# Reiniciar
	current_angular_speed = 0.0
	is_suspension_active = false
	chasis.rotation_degrees = 0
	chasis.position.y = 0

	# 1. ACELERÓN: levantar chasis
	var lift_tween = create_tween()
	lift_tween.set_parallel(false)
	lift_tween.tween_property(chasis, "rotation_degrees", lift_angle, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	lift_tween.tween_property(chasis, "rotation_degrees", 0, lift_duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	# 2. RUEDAS: acelerar
	var target_speed = max_speed if go_left else -max_speed
	var wheel_tween = create_tween()
	wheel_tween.tween_method(_set_angular_speed, 0.0, target_speed, acceleration_time)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 3. SUSPENSIÓN: activar a mitad de aceleración
	var suspension_timer = get_tree().create_timer(suspension_start_delay)
	suspension_timer.timeout.connect(_start_suspension)
	
	exhaust_smoke.emitting = true
	exhaust_smoke.set_intensity(true)  # ¡Llama a la función!

	get_tree().create_timer(acceleration_time).timeout.connect(func():
		exhaust_smoke.emitting = false
	)

# === VELOCIDAD RUEDAS ===
func _set_angular_speed(speed: float):
	current_angular_speed = speed

func _process(delta):
	if abs(current_angular_speed) > 0.01:
		wheel_front.rotation_degrees += current_angular_speed * delta
		wheel_rear.rotation_degrees += current_angular_speed * delta

# === SUSPENSIÓN ALEATORIA ===
func _start_suspension():
	if is_suspension_active: return
	is_suspension_active = true
	_run_suspension_loop()

func _run_suspension_loop():
	if !is_suspension_active: return

	suspension_tween = create_tween()
	var random_y = randf_range(-suspension_amplitude, suspension_amplitude)
	suspension_tween.tween_property(chasis, "position:y", random_y, 1.0 / suspension_frequency)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	suspension_tween.finished.connect(_run_suspension_loop)

# === CONTROL EXTERNO ===
func set_direction(forward: bool):
	go_left = forward
	start_wheel_animation()

func stop_wheels():	
	current_angular_speed = 0.0
	is_suspension_active = false
	
	exhaust_smoke.emitting = false  # ← PARA HUMO
	
	if suspension_tween: suspension_tween.kill()
	# Suavizar parada
	var stop_tween = create_tween()
	stop_tween.tween_property(chasis, "position:y", 0, 0.3)
	stop_tween.tween_property(chasis, "rotation_degrees", 0, 0.5)
