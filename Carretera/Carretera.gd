class_name Carretera extends Node2D

@onready var parallax_2d_murete: Parallax2D = $Parallax2DMurete
@onready var parallax_2d_asphalt: Parallax2D = $Parallax2DAsphalt
@onready var parallax_2d_palms_tras: Parallax2D = $Parallax2DPalmsTras
@onready var parallax_2d_palms: Parallax2D = $Parallax2DPalms
@onready var coche: CocheScene = $CocheScene
@onready var km: Label = $Panel/km

@onready var quiz: Quiz = $Quiz
@onready var quiz_canvas: CanvasLayer = $Quiz/CanvasLayer


# Velocidades máximas
const MAX_FORWARD_SPEED: float = -1200.0  # Izquierda (adelante)
const MAX_REVERSE_SPEED: float = 800.0    # Derecha (marcha atrás)

var km_count: float = 0.0
var km_to_show_quiz: float = 0.5
var quiz_km_counter: float = 0.0
var quiz_end: bool = false

# Aceleración / Desaceleración
const ACCELERATION: float = 3000.0
const DECELERATION: float = 4000.0

var current_speed: float = 0.0

var idle: bool = true
var mode_quiz: bool = false

# Factores de parallax
const MURETE_FACTOR: float = 1.0
const ASPHALT_FACTOR: float = 1.0
const PALMS_TRAS_FACTOR: float = 1.0
const PALMS_FACTOR: float = 2.0

func _ready() -> void:
	quiz.question_answered_correctly.connect(_on_quiz_question_correct)
	mode_quiz = false
	quiz_canvas.visible = false
	set_all_autoscroll(Vector2.ZERO)
	$CocheScene.set_driver_inside()
	
func _on_quiz_question_correct(msg='') -> void:
	print("¡El jugador ha acertado una pregunta del quiz!")
	quiz_canvas.visible = false
	mode_quiz = false
	Global.show_lateral_panel()
	if msg=='the_end':
		quiz_end = true

func _physics_process(delta: float) -> void:
	if mode_quiz:
		return
		
	var right_pressed = Input.is_action_pressed("right")
	var left_pressed = Input.is_action_pressed("left")
	
	if right_pressed and not left_pressed:
		current_speed = move_toward(current_speed, MAX_FORWARD_SPEED, ACCELERATION * delta)		
	elif left_pressed and not right_pressed:
		if current_speed < 0:
			current_speed = move_toward(current_speed, 0.0, DECELERATION * delta)
		else:
			current_speed = move_toward(current_speed, MAX_REVERSE_SPEED, ACCELERATION * delta)			
	else:
		current_speed = move_toward(current_speed, 0.0, DECELERATION * delta * 0.6)
	
	# Aplicar movimiento
	var displacement = Vector2(current_speed * delta, 0)
	parallax_2d_murete.scroll_offset += displacement * MURETE_FACTOR
	parallax_2d_asphalt.scroll_offset += displacement * ASPHALT_FACTOR
	parallax_2d_palms_tras.scroll_offset += displacement * PALMS_TRAS_FACTOR
	parallax_2d_palms.scroll_offset += displacement * PALMS_FACTOR
	
	if current_speed == 0.0:
		idle = true
		coche.driver.play("idle")
	else:
		idle = false
		coche.driver.play("driving")
		
	var inc = current_speed * 0.000005
	km_count -= inc
	quiz_km_counter -= inc
	#print(quiz_km_counter)
	km.text = "KM: %.2f" % km_count
	if quiz_km_counter > km_to_show_quiz:
		_show_quiz()
	if km_count > 5:
		print(km_count)
		change_to_street()

func _show_quiz():
	if quiz_end or Global.second_chance:
		mode_quiz = false
		return
	Global.hide_lateral_panel()
	mode_quiz = true
	quiz_km_counter = 0
	quiz_canvas.visible = true

func set_all_autoscroll(speed: Vector2) -> void:
	parallax_2d_murete.autoscroll = speed
	parallax_2d_asphalt.autoscroll = speed
	parallax_2d_palms_tras.autoscroll = speed
	parallax_2d_palms.autoscroll = speed

func change_to_street() -> void:
	Global.player_pos_x = -10.0
	Global.change_room(Global.ROOM_STREET)
