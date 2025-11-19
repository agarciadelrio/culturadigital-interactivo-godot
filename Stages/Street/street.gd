class_name Street extends Node2D

@onready var shop_door: Area2D = $ShopDoor
@onready var person_lr_scene: PersonLR = $PersonLRScene
@onready var coche: CocheScene = $CocheScene

var player_in_shop_door: bool = false

func _ready() -> void:
	if Global.player_pos_x > 0.0:		
		person_lr_scene.visible = true # Reset
		person_lr_scene.position.x = 235.0
		car_arriving(false)
	else:
		person_lr_scene.visible = false
		person_lr_scene.position.x = -100.0
		car_arriving(true)
	Global.player_pos_x = -200.0
	_connect_door_signals()	
	
func _process(_delta: float) -> void:
	if player_in_shop_door and Input.is_action_pressed("up"):
		change_to_shop_room()

func car_arriving(landing:bool) -> void:
	if landing:
		var start_x = coche.global_position.x
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)   # Aceleración suave
		tween.set_ease(Tween.EASE_OUT)       # Empieza rápido, termina lento
		
		# Mueve 120 píxeles hacia la DERECHA (+120)
		tween.tween_property(coche, "global_position:x", start_x + 400, 3)
		
		# Cuando termine el movimiento → cambiar escena
		tween.tween_callback(func():
			coche.driver.play("empty")
			person_lr_scene.visible = true
		)
	else:
		coche.driver.play("empty")
		coche.global_position.x = -140

# ──────────────────────────────────────────────
# CONECTA SEÑALES DE PUERTAS
# ──────────────────────────────────────────────
func _connect_door_signals() -> void:
	shop_door.body_entered.connect(_on_shop_door_body_entered.bind(shop_door))
	shop_door.body_exited.connect(_on_shop_door_body_exited.bind(shop_door))


# ──────────────────────────────────────────────
# ENTRADA EN PUERTA (generalizado)
# ──────────────────────────────────────────────
func _on_shop_door_body_entered(body: Node2D, door: Area2D) -> void:
	if not body.is_in_group("player"):
		return
	
	match door:
		shop_door:
			player_in_shop_door = true			

# ──────────────────────────────────────────────
# SALIDA DE PUERTA
# ──────────────────────────────────────────────
func _on_shop_door_body_exited(body: Node2D, door: Area2D) -> void:
	if not body.is_in_group("player"):
		return
	
	match door:
		shop_door:  player_in_shop_door = false		
		
# ──────────────────────────────────────────────
# CAMBIO DE ESCENA
# ──────────────────────────────────────────────
func change_to_shop_room() -> void:
	Global.player_pos_x = 0.0
	Global.change_room(Global.ROOM_SHOP)
