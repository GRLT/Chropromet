extends Control

@onready var start_button: Button = $CanvasLayer/VBoxContainer/Start_Button
@onready var options_button: Button = $CanvasLayer/VBoxContainer/Options_Button
@onready var exit_button: Button = $CanvasLayer/VBoxContainer/Exit_Button


func _ready() -> void:
    start_button.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Node.tscn")
        )
    options_button.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Options.tscn")
        )
    exit_button.pressed.connect(
        func() -> void:
        get_tree().quit(0)
        )
