extends Control

@onready var start_button: Button = $CanvasLayer/VBoxContainer/Start_Button
@onready var options_button: Button = $CanvasLayer/VBoxContainer/Options_Button
@onready var exit_button: Button = $CanvasLayer/VBoxContainer/Exit_Button


func _ready() -> void:
	start_button.pressed.connect(start_button_pressed)
	options_button.pressed.connect(options_button_pressed)
	exit_button.pressed.connect(exit_button_pressed)


func start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Node.tscn")


func options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Options.tscn")


func exit_button_pressed() -> void:
	get_tree().quit(0)
