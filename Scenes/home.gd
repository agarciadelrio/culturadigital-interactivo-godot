class_name Home
extends Node2D

func _ready() -> void:	
	Global.ui_hide()


func _on_btn_enter_pressed() -> void:
	Global.reset_counters()
	Global.change_room(Global.ROOM_LIVING)
