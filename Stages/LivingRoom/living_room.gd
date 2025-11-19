class_name LivingRoom extends Node2D

#signal pick_item

@export var pos_char_x: float = 0.0 : set = set_pos_char_x
@onready var person_td_scene: PersonTD = $PersonTDScene
@onready var door_left: Area2D = $DoorLeft
@onready var door_right: Area2D = $DoorRight

var player_in_left_door: bool = false
var player_in_right_door: bool = false

func _ready() -> void:
	$BtnWallet.visible = not "wallet" in Global.inventory
	if Global.player_pos_x != 0.0:
		pos_char_x = Global.player_pos_x
		Global.player_pos_x = 0.0  # Reset
	update_character_position()
	_connect_door_signals()
	Global.ui_show()

func _process(_delta: float) -> void:
	if player_in_left_door and Input.is_action_pressed("left"):
		change_to_edit_room()
	elif player_in_right_door and Input.is_action_pressed("right"):
		change_to_garage()

# ──────────────────────────────────────────────
# SETTER: Actualiza posición al cambiar en Inspector
# ──────────────────────────────────────────────
func set_pos_char_x(value: float) -> void:
	pos_char_x = value
	update_character_position()

# ──────────────────────────────────────────────
# ACTUALIZA POSICIÓN DEL PERSONAJE
# ──────────────────────────────────────────────
func update_character_position() -> void:
	if not person_td_scene:
		push_warning("PersonTDScene no encontrado en LivingRoom")
		return
	
	if pos_char_x < 0:
		person_td_scene.position.x = -240.0
	elif pos_char_x > 0:
		person_td_scene.position.x = 240.0
	else:
		person_td_scene.position.x = 0.0

# ──────────────────────────────────────────────
# CONECTA SEÑALES DE PUERTAS
# ──────────────────────────────────────────────
func _connect_door_signals() -> void:
	door_left.body_entered.connect(_on_door_body_entered.bind(door_left))
	door_left.body_exited.connect(_on_door_body_exited.bind(door_left))
	door_right.body_entered.connect(_on_door_body_entered.bind(door_right))
	door_right.body_exited.connect(_on_door_body_exited.bind(door_right))

# ──────────────────────────────────────────────
# ENTRADA EN PUERTA (generalizado)
# ──────────────────────────────────────────────
func _on_door_body_entered(body: Node2D, door: Area2D) -> void:
	if not body.is_in_group("player"):
		return
	
	match door:
		door_left:
			player_in_left_door = true
			player_in_right_door = false
		door_right:
			player_in_right_door = true
			player_in_left_door = false

# ──────────────────────────────────────────────
# SALIDA DE PUERTA
# ──────────────────────────────────────────────
func _on_door_body_exited(body: Node2D, door: Area2D) -> void:
	if not body.is_in_group("player"):
		return
	
	match door:
		door_left:  player_in_left_door = false
		door_right: player_in_right_door = false

# ──────────────────────────────────────────────
# CAMBIO DE ESCENA
# ──────────────────────────────────────────────
func change_to_edit_room() -> void:
	Global.player_pos_x = 10.0
	Global.change_room(Global.ROOM_EDIT)

func change_to_garage() -> void:
	Global.change_room(Global.ROOM_GARAGE)
	#Global.change_room(Global.ROOM_SHOP)

func _on_button_pressed() -> void:
	print("PICK CARTERA")
	#pick_item.emit('wallet')
	Global.on_pick_item('wallet')
	$BtnWallet.queue_free()
