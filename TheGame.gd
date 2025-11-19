class_name TheGame extends Node2D

@onready var main_scene: Node = $MainScene
@onready var panel_lateral: CanvasLayer = $PanelLateral
@onready var lbl_readed: Label = $PanelLateral/VBoxContainer/LblReaded
@onready var lbl_ok: Label = $PanelLateral/VBoxContainer/LblOk
@onready var lbl_fail: Label = $PanelLateral/VBoxContainer/LblFail

var current_room: Node = null
var _dialog_is_open: bool = false

func _ready() -> void:
	randomize()
	#change_room(Global.ROOM_LIVING)	
	#change_room(Global.ROOM_DESKTOP)	
	#change_room(Global.ROOM_GARAGE)
	#change_room(Global.ROOM_ROAD)
	#change_room(Global.ROOM_SHOP)
	change_room(Global.ROOM_ENTER)	
	ui_hide()
	

# ------------------------------------------------------------------
# Función llamada desde Global.change_room()
func change_room(scene_path: String) -> void:
	if not main_scene:
		push_error("TheGame: No se encontró RoomContainer. Añade un Node llamado 'RoomContainer'.")
		return
	
	# Eliminar habitación anterior
	if current_room:
		current_room.queue_free()
	
	# Cargar e instanciar la nueva
	var new_room_scene: PackedScene = load(scene_path)
	if not new_room_scene:
		push_error("TheGame: No se pudo cargar la escena: " + scene_path)
		return
	
	current_room = new_room_scene.instantiate()
	main_scene.add_child(current_room)
	#Global.set_pick_item_signal(current_room)
	
	print("[TheGame] → Cambiada habitación a: ", scene_path)
# ------------------------------------------------------------------

func _on_dialog_closed(dialog: AcceptDialog) -> void:
	main_scene.get_tree().paused = false
	_dialog_is_open = false
	if is_instance_valid(dialog):
		dialog.queue_free() 
	print("Diálogo cerrado – el juego continúa")

func show_dialog(title:String, text:String) -> void:
	if _dialog_is_open: return
	
	_dialog_is_open = true
	var dialog = AcceptDialog.new()
	
	dialog.title = title
	dialog.dialog_text = text  
	dialog.exclusive = true
	dialog.dialog_hide_on_ok = false
	# aquí hay que forzar a que sea un entero	
	dialog.process_mode = int(Node.PROCESS_MODE_ALWAYS)
	
	# Conexiones
	dialog.confirmed.connect(func(): _on_dialog_closed(dialog))
	dialog.canceled.connect(func(): _on_dialog_closed(dialog))
	dialog.close_requested.connect(func(): _on_dialog_closed(dialog))
	
	main_scene.get_tree().root.add_child(dialog)
	dialog.popup_centered()
	
	main_scene.get_tree().paused = true

func ui_hide():
	print("hide_ui")
	await get_tree().process_frame  # espera 1 frame
	await get_tree().process_frame
	panel_lateral.hide()

func ui_show():
	print("show_ui")
	await get_tree().process_frame  # espera 1 frame
	await get_tree().process_frame
	panel_lateral.show()
