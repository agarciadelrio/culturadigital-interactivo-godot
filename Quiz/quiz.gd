class_name Quiz
extends Node2D

signal question_answered_correctly

@onready var title: Label = $CanvasLayer/VBoxContainer/Panel/Title
@onready var A: Label = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer/BtnA/A
@onready var B: Label = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer/BtnB/B
@onready var C: Label = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer2/BtnC/C
@onready var D: Label = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer2/BtnD/D

@onready var btn_a: Button = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer/BtnA
@onready var btn_b: Button = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer/BtnB
@onready var btn_c: Button = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer2/BtnC
@onready var btn_d: Button = $CanvasLayer/VBoxContainer/VBoxContainer/HBoxContainer2/BtnD
@onready var btn_close: Button = $CanvasLayer/BtnClose

@onready var attemp_counter: Label = $CanvasLayer/AttempCounter

var ConfettiScene = preload("res://Pruebas/TestConfetti.tscn") # ¡Ajusta la ruta si es necesario!

var questions: Array = []
var current_question_index: int = 0
var correct_answers: int = 0
var wrong_attempts: int = 0
var current_correct_answer: String = ""

var style_normal: StyleBoxFlat
var style_wrong: StyleBoxFlat
var style_correct: StyleBoxFlat

func _ready() -> void:	
	if Global.quiz_data.is_empty():
		Global.load_quiz_once()
	
	questions = Global.quiz_data.duplicate()
	questions.shuffle()
	_set_question(current_question_index)
	
	_reset_all_buttons()
	
	btn_close.visible = false
	btn_a.pressed.connect(func(): _on_answer_pressed("A", btn_a))
	btn_b.pressed.connect(func(): _on_answer_pressed("B", btn_b))
	btn_c.pressed.connect(func(): _on_answer_pressed("C", btn_c))
	btn_d.pressed.connect(func(): _on_answer_pressed("D", btn_d))
	
	attemp_counter.text = "Fallos: 0"	

func _reset_all_buttons() -> void:
	for btn in [btn_a, btn_b, btn_c, btn_d]:
		btn.disabled = false
		btn.mouse_filter = Control.MOUSE_FILTER_STOP

func _set_question(idx: int) -> void:
	if idx >= questions.size():
		_show_final_score()
		return	
	var q = questions[idx]
	title.text = q.title
	A.text = q.A
	B.text = q.B
	C.text = q.C
	D.text = q.D
	current_correct_answer = q.correct
	_reset_all_buttons()

func _on_answer_pressed(answer: String, button: Button) -> void:	
	if answer == current_correct_answer:
		Global.inc_ok()		
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE		
		correct_answers += 1
		#button.add_theme_stylebox_override("panel", style_correct)		
		
		# Creamos una nueva instancia del confeti.
		var new_confetti = ConfettiScene.instantiate() as Confetti
		
		# La añadimos como hijo del CanvasLayer 
		$CanvasLayer.add_child(new_confetti)
		new_confetti.move_to_front()
		new_confetti.z_index = 1000
		
		# Posicionamos en el centro de la pantalla (0,0 del CanvasLayer).
		new_confetti.position = Vector2.ZERO
		
		# Disparamos la explosión. new_confetti se borrará solo.
		new_confetti.start_explosion()
		
		# Efectos
		_flash_feedback(Color(0.1, 0.8, 0.1, 0.4))			
		await get_tree().create_timer(2.5).timeout
		
		# Envía señal de respuesta correcta
		question_answered_correctly.emit()
		
		# Pasa a la siguiente
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		current_question_index += 1
		_set_question(current_question_index)
	else:
		Global.inc_fail()
		button.disabled = true		
		wrong_attempts += 1
		attemp_counter.text = "Fallos: %d" % wrong_attempts	
		_flash_feedback(Color(0.8, 0.1, 0.1, 0.5))
		await get_tree().create_timer(2.5).timeout

func _flash_feedback(color: Color) -> void:
	print("FLASH")
	var flash = ColorRect.new()
	flash.color = color
	flash.size = get_viewport().size
	flash.z_index = 100 
	$CanvasLayer.add_child(flash)			
	var tween = create_tween()
	tween.tween_property(flash, "color:a", 0.0, 0.6)
	tween.tween_callback(flash.queue_free)

func _show_final_score() -> void:
	title.text = "¡Quiz completado!\nAciertos: %d/%d\nFallos: %d" % [correct_answers, questions.size(), wrong_attempts]
	attemp_counter.text = "Fallos totales: %d" % wrong_attempts
	btn_close.visible = true
	for btn in [btn_a, btn_b, btn_c, btn_d]:
		btn.visible = false

func _on_button_button_down() -> void:
	question_answered_correctly.emit('the_end')
