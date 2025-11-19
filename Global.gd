extends Node

const ROOM_LIVING = "res://Scenes/LivingRoom.tscn"
const ROOM_STREET = "res://Scenes/Street.tscn"
const ROOM_EDIT = "res://Scenes/EditRoom.tscn"
const ROOM_DESKTOP = "res://Scenes/Desktop.tscn"
const ROOM_SHOP = "res://Scenes/Shop.tscn"
const ROOM_GARAGE = "res://Scenes/Garage.tscn"
const ROOM_ROAD = "res://Carretera/Carretera.tscn"
const ROOM_ENTER = "res://Scenes/Home.tscn"
#const THE_GAME = preload("res://TheGame.tscn")

var player_pos_x: float = 0.0
var the_game: TheGame
var quiz_data: Array = []
var quiz_loaded: bool = false
var inventory: Array = []
var second_chance : bool = false
const ITEM_MAP: Dictionary =  {	
	"keys": "res://Inventario/Llaves.png",
	"tape": "res://Inventario/Cinta.png",
	"wallet": "res://Inventario/Cartera.png"
}
var count_readed: int = 0
var count_ok: int = 0
var count_fail: int = 0

func _ready():
	load_quiz_once()
	# Esperar un frame para asegurar que TheGame esté cargado
	await get_tree().process_frame		
	_connect_pick_item()
	the_game = get_tree().get_root().get_node_or_null("TheGame") as TheGame
	print_counters()

func reset_counters():
	count_readed = 0
	count_ok = 0
	count_fail = 0
	print_counters()


func set_pick_item_signal(_node: Node):
	print("SETTING PICK ITEM SIGNAL")
	#self.get_tree().node_added.connect(_on_node_added)

func _connect_pick_item():
	#get_tree().node_added.connect(_on_node_added)
	pass
	
func _on_node_added(_node: Node) -> void:
	#if node.has_signal("pick_item"):
	#	node.pick_item.connect(_on_pick_item)
	pass

func on_pick_item(item_id: String) -> void:
	print("ON PICK")
	if item_id not in inventory:
		await get_tree().process_frame  # espera 1 frame
		await get_tree().process_frame
		_insert_in_the_game_inventory_box(item_id)
		inventory.append(item_id)
		print("¡Objeto recogido! → ", item_id)
		print("Inventario actual: ", inventory)
	else:
		print("Ya tienes este objeto: ", item_id)

func show_lateral_panel():
	if not the_game: return
	the_game.panel_lateral.visible = true
	
func hide_lateral_panel():
	if not the_game: return
	the_game.panel_lateral.visible = false

func _insert_in_the_game_inventory_box(item_id: String) -> void:
	if not the_game: return	
	var box : VBoxContainer = the_game.get_node_or_null("PanelLateral/VBoxContainer/Panel/InventoryBox")
	if not box: return
	
	# Evitamos duplicados
	for child in box.get_children():
		if child.has_meta("item_id") and child.get_meta("item_id") == item_id:
			return  # ya está en el inventario
	# Ruta de la textura
	var texture_path: String = ITEM_MAP.get(item_id, "")
	if texture_path.is_empty():
		push_error("Item no encontrado en ITEM_MAP: ", item_id)
		return
	
	var texture := load(texture_path) as Texture2D
	if not texture:
		push_error("No se pudo cargar la textura: ", texture_path)
		return
		
	# Creamos un TextureRect para la imagen
	var item_icon := TextureRect.new()
	item_icon.texture = texture
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED	
	item_icon.custom_minimum_size = Vector2(0, 32)   # altura fija de 64px
	#item_icon.expand_mode = TextureRect.EXPAND_FIT_HEIGHT   # mantiene proporción
	item_icon.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL   # ← esta es la clave para que se vea bien
	item_icon.size_flags_vertical = Control.SIZE_EXPAND_FILL	
	
	# Guardamos el ID para evitar duplicados
	item_icon.set_meta("item_id", item_id)	
	box.add_child(item_icon)
		
func load_quiz_once() -> void:
	if quiz_loaded:
		return  # ← Ya cargado, no hacemos nada
	
	var file = FileAccess.open("res://Quiz/quiz.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(content)
		if parsed is Array and parsed.size() > 0:
			quiz_data = parsed[0].get("questions", []).duplicate()  
			quiz_loaded = true
			print("Quiz cargado en Global (una sola vez)")
		else:
			push_error("JSON del quiz inválido")
	else:
		push_error("No se pudo abrir quiz.json")

func change_room(new_scene_path: String):
	print("change_room **************")
	if the_game:
		print("CHANGE THE ROOM")
		the_game.change_room(new_scene_path)
		_connect_pick_item()
	else:
		push_error("TheGame no encontrado. Verifica que esté en la raíz.")
		print(new_scene_path)

func show_dialog(title:String, text:String):
	if not the_game: return	
	the_game.show_dialog(title, text)

func ui_hide():
	if not the_game: return	
	await get_tree().process_frame  # espera 1 frame
	await get_tree().process_frame
	the_game.ui_hide()
	
func ui_show():
	if not the_game: return	
	await get_tree().process_frame  # espera 1 frame
	await get_tree().process_frame
	the_game.ui_show()

func print_counters():
	the_game.lbl_readed.text = "Fichas leídas: %d" % count_readed
	the_game.lbl_ok.text = "Preguntas acertadas: %d" % count_ok
	the_game.lbl_fail.text = "Preguntas falladas: %d" % count_fail
	
func inc_readed():
	if not the_game: return
	count_readed += 1
	print_counters()

func inc_ok():
	if not the_game: return
	count_ok += 1
	print_counters()

func inc_fail():
	if not the_game: return
	count_fail += 1
	print_counters()
