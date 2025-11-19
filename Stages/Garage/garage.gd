class_name Garage extends Node2D

@onready var door_left: Area2D = $Garage/DoorLeft
@onready var person_lr_scene: PersonLR = $Person
@onready var coche: CocheScene = $Coche
@onready var car_door: Area2D = $Coche/CarDoor

var player_in_left_door: bool = false
var player_in_car_door: bool = false
var driver_inside_car: bool = false
var driver_outside_position: Vector2 = Vector2.ZERO
var driver_ready_to_go: bool = false

func _ready() -> void:	
	person_lr_scene.position.x = -230.0
	coche.driver.play("empty")
	_connect_door_signals()
	#await get_tree().process_frame  # espera 1 frame
	#await get_tree().process_frame  # espera otro por si acaso (nunca falla)
	#Global.on_pick_item('keys')
	$Coche.set_driver_outside()

func _process(_delta: float) -> void:
	if player_in_left_door and Input.is_action_pressed("left"):
		change_to_living_room()		
	elif player_in_car_door and Input.is_action_just_pressed("down"):
		change_to_enter_car()		
	elif driver_inside_car and Input.is_action_pressed("up"):
		change_to_out_car()
	elif driver_ready_to_go and Input.is_action_pressed("right"):
		change_to_car_start_move()

# ──────────────────────────────────────────────
# CONECTA SEÑALES DE PUERTA
# ──────────────────────────────────────────────
func _connect_door_signals() -> void:
	door_left.body_entered.connect(_on_door_body_entered.bind(door_left))
	door_left.body_exited.connect(_on_door_body_exited.bind(door_left))
	car_door.body_entered.connect(_on_car_door_entered.bind(car_door))
	car_door.body_exited.connect(_on_car_door_exited.bind(car_door))

# ──────────────────────────────────────────────
# ENTRADA EN PUERTA DERECHA
# ──────────────────────────────────────────────
func _on_door_body_entered(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_left_door = true

# ──────────────────────────────────────────────
# SALIDA DE PUERTA DERECHA
# ──────────────────────────────────────────────
func _on_door_body_exited(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_left_door = false

func _on_car_door_entered(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_car_door = true
		print("_on_car_door_entered")
	
func _on_car_door_exited(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_car_door = false

# ──────────────────────────────────────────────
# VOLVER A LIVINGROOM
# ──────────────────────────────────────────────
func change_to_living_room() -> void:
	Global.player_pos_x = 1.0
	Global.change_room(Global.ROOM_LIVING)

####XXX

func change_to_enter_car() -> void:
	if not "keys" in Global.inventory:
		Global.show_dialog("¡Faltan las llaves!", "¿Dónde las habré metido?"   )
		return
		
	driver_inside_car = true		
	driver_outside_position = person_lr_scene.global_position
	person_lr_scene.visible = false
	# SOLO conecta si NO está ya conectada
	if not coche.driver.animation_finished.is_connected(_on_enter_car_finished):
		coche.driver.animation_finished.connect(_on_enter_car_finished, CONNECT_ONE_SHOT)		
		
	coche.driver.play("entering")

####XXX

func _on_enter_car_finished() -> void:
	# Esta función se ejecuta AUTOMÁTICAMENTE cuando termina "entering"
	coche.driver.play("idle")
	driver_ready_to_go = true
	$Coche.set_driver_inside()
	
func change_to_out_car() -> void:
	person_lr_scene.global_position = driver_outside_position
	driver_inside_car = false	
	driver_ready_to_go = false
	$Coche.set_driver_outside()
	coche.driver.play_backwards("entering")
	coche.driver.animation_finished.connect(_on_exit_car_finished, CONNECT_ONE_SHOT)
	
func _on_exit_car_finished() -> void:
	coche.driver.play("empty")
	person_lr_scene.visible = true	
	
func change_to_car_start_move() -> void:
	var start_x = coche.global_position.x
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)   # Aceleración suave
	tween.set_ease(Tween.EASE_OUT)       # Empieza lento, termina rápido
	
	# Mueve 120 píxeles hacia la DERECHA (+120)
	tween.tween_property(coche, "global_position:x", start_x + 9, .5)
	
	# Cuando termine el movimiento → cambiar escena
	tween.tween_callback(func():
		Global.change_room("res://Carretera/Carretera.tscn")
	)
