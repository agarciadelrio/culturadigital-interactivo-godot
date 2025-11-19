class_name EditRoom extends Node2D

@onready var door_right: Area2D = $EditRoom/DoorRight
@onready var video_desk_top: Area2D = $EditRoom/VideoDeskTop
@onready var person_td_scene: PersonTD = $PersonTDScene

var player_in_right_door: bool = false
var player_in_desktop: bool = false


func _ready() -> void:
	# Fuerza la posición del personaje al entrar
	if Global.player_pos_x == 0.0:
		person_td_scene.position.x =0.0		# Reset
	else:
		person_td_scene.position.x = 214.0	
	Global.player_pos_x = 0.0 
	_connect_door_signals()

func _process(_delta: float) -> void:
	if player_in_right_door and Input.is_action_pressed("right"):
		change_to_living_room()
	elif player_in_desktop and Input.is_action_pressed("up"):
		change_to_desktop()

# ──────────────────────────────────────────────
# CONECTA SEÑALES DE PUERTA
# ──────────────────────────────────────────────
func _connect_door_signals() -> void:
	door_right.body_entered.connect(_on_door_body_entered.bind(door_right))
	door_right.body_exited.connect(_on_door_body_exited.bind(door_right))
	video_desk_top.body_entered.connect(_on_desktop_body_entered.bind(video_desk_top))
	video_desk_top.body_exited.connect(_on_desktop_body_exited.bind(video_desk_top))

# ──────────────────────────────────────────────
# ENTRADA EN PUERTA DERECHA
# ──────────────────────────────────────────────
func _on_door_body_entered(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_right_door = true

# ──────────────────────────────────────────────
# SALIDA DE PUERTA DERECHA
# ──────────────────────────────────────────────
func _on_door_body_exited(body: Node2D, _door: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_right_door = false

# ──────────────────────────────────────────────
# VOLVER A LIVINGROOM
# ──────────────────────────────────────────────
func change_to_living_room() -> void:
	Global.player_pos_x = -1.0
	Global.change_room(Global.ROOM_LIVING)
	
# ──────────────────────────────────────────────
# ENTRADA EN DESKTOP
# ──────────────────────────────────────────────
func _on_desktop_body_entered(body: Node2D, _desktop: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_desktop = true

# ──────────────────────────────────────────────
# SALIDA DE DESKTOP
# ──────────────────────────────────────────────
func _on_desktop_body_exited(body: Node2D, _desktop: Area2D) -> void:
	if body.is_in_group("player"):
		player_in_desktop = false
		
# ──────────────────────────────────────────────
# ABRE DESKTOP
# ──────────────────────────────────────────────
func change_to_desktop() -> void:
	Global.player_pos_x = -1.0
	Global.change_room(Global.ROOM_DESKTOP)
