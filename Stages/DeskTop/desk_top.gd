class_name DeskTop extends Node2D

@onready var post_it_container: Control = $PostItContainer
@onready var post_it_modal: Control = $Modal
@onready var modal_title_label: Label = $Modal/Panel/ModalBackground/ModalContent/ModalTitleLabel
@onready var modal_info_label: Label = $Modal/Panel/ModalBackground/ModalContent/ModalInfoLabel
@onready var modal_close_button: Button = $Modal/Panel/ModalBackground/ModalContent/ModalCloseButton
@onready var modal_content: VBoxContainer = $Modal/Panel/ModalBackground/ModalContent
@onready var monitor: Panel = $Monitor
@onready var video: VideoStreamPlayer = $Monitor/Video
@onready var desk_top: Node2D = $DeskTop
@onready var btn_llaves: Button = $BtnLlaves

var _cards_data = []
var post_it_texture = preload("res://Stages/DeskTop/post-it.png")
var post_it_readed_texture = preload("res://Stages/DeskTop/post-it-readed.png")
var _current_pressed_post_it: TextureButton

func _ready() -> void:
	#Global.on_pick_item("tape")		
	$BtnLlaves.visible = not "keys" in Global.inventory
	post_it_modal.hide()
	modal_close_button.pressed.connect(_on_modal_close_button_pressed)
	_load_cards_data()
	_generate_post_it_notes()
	await get_tree().process_frame  # espera 1 frame
	await get_tree().process_frame
	if "tape" in Global.inventory:
		video_play()
	else:
		video_stop()

func video_play():	
	Global.ui_hide()
	post_it_container.hide()
	btn_llaves.hide()
	monitor.visible = true
	video.play()
	video.finished.connect(_on_video_finished)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(video, "scale", Vector2(4.5, 4.5), 4.0)	
	tween.tween_property(video, "position:y", video.position.y - 50, 4.0)
	tween.tween_property(desk_top, "modulate:a", 0.0, 4.0)    
	
func video_stop():
	monitor.visible = false
	video.stop()
	
func _on_video_finished():
	print("VIDEO FIN")
	await get_tree().create_timer(2.5).timeout
	Global.change_room(Global.ROOM_ENTER)
	
func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("down"):
		change_to_edit_room()

func _load_cards_data():
	var file = FileAccess.open("res://Stages/DeskTop/cards.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		_cards_data = JSON.parse_string(content)
		file.close()
		if _cards_data is Array:
			print("Cards data loaded successfully.")
		else:
			print("Error parsing cards.json: Not a valid JSON array.")
			_cards_data = []
	else:
		print("Error opening cards.json")
		_cards_data = []
		
func change_to_edit_room() -> void:
	Global.player_pos_x = 0
	Global.change_room(Global.ROOM_EDIT)

func _on_post_it_pressed(button: TextureButton, card_data):
	_current_pressed_post_it = button
	button.texture_normal = post_it_readed_texture
	modal_title_label.text = card_data.title
	modal_info_label.text = card_data.info
	post_it_modal.show()
	#print("CLICK", card_data)
	Global.inc_readed()

func _on_modal_close_button_pressed():
	post_it_modal.hide()
	if _current_pressed_post_it:
		_current_pressed_post_it.texture_normal = post_it_readed_texture

func _generate_post_it_notes():
	for child in post_it_container.get_children():
		child.queue_free()
	
	var all_cards = []
	for category in _cards_data:
		for card in category.cards:
			all_cards.append(card)
	
	# LIMITAR A MÁXIMO 12 si el contenedor es pequeño (evita caos)
	if post_it_container.get_rect().size.length() < 600:
		all_cards.shuffle()
		all_cards.resize(min(20, all_cards.size()))
		print("Contenedor pequeño → solo se generan ", all_cards.size(), " post-its")
	
	var container_rect = post_it_container.get_rect()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var placed_positions = []

	# AUTOAJUSTE de min_distance según tamaño y cantidad
	var area = container_rect.size.x * container_rect.size.y
	var desired_distance = sqrt(area / (all_cards.size() + 1)) * 0.9
	var min_distance = clamp(desired_distance, 60.0, 180.0)
	print("Distancia mínima autoajustada: ", min_distance)
	
	var max_attempts = 300
	
	for card in all_cards:
		var post_it = TextureButton.new()
		post_it.texture_normal = post_it_texture
		post_it.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		post_it.scale = Vector2(0.08, 0.08)
		
		var pos = Vector2.ZERO
		var placed = false
		var attempts = 0
		
		while not placed and attempts < max_attempts:
			pos.x = rng.randf_range(0, container_rect.size.x - 100)
			pos.y = rng.randf_range(0, container_rect.size.y - 10)
			
			placed = true
			for p in placed_positions:
				if pos.distance_to(p) < min_distance:
					placed = false
					break
			attempts += 1
		
		if not placed:
			print("Forzando posición (no cabía más)")
		
		placed_positions.append(pos)
		post_it.position = pos
		post_it.rotation_degrees = rng.randf_range(-15, 15)
		post_it.set_meta("card_data", card)
		post_it.pressed.connect(func(): _on_post_it_pressed(post_it, card))
		post_it_container.add_child(post_it)

func _on_btn_llaves_pressed() -> void:
	print("PICK LLAVES")	
	Global.on_pick_item('keys')
	$BtnLlaves.queue_free()
