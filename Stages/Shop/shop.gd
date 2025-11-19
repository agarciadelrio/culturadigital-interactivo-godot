class_name Shop extends Node2D

#signal pick_item

func _ready() -> void:
	$BtnCinta.visible = not "tape" in Global.inventory
	#Global.on_pick_item('wallet')

func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("down"):
		exit_from_shop()

func exit_from_shop() -> void:
	Global.second_chance = true
	Global.player_pos_x = 10
	#Global.change_room(Global.ROOM_STREET)
	Global.change_room(Global.ROOM_LIVING)

func _on_btn_cinta_pressed() -> void:
	if not "wallet" in Global.inventory:
		Global.show_dialog("¿699 pesetas, tamos locos!!!?", "La cinta cuesta un dineral y te has dejado la cartera en casa.")
		return
	Global.show_dialog("¿699 pesetas, tamos locos!!!?", "Todo sea por entregar a tiempo este trabajo.\nHora de volver a casa para volcar la cinta para el cliente.")
	print("PICK CINTA")	
	Global.on_pick_item('tape')
	$BtnCinta.queue_free()
