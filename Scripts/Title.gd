extends Control

#@onready var start_button: Button = $CanvasLayer/BoxContainer/Start_Button
@onready var load_button: Button = $CanvasLayer/BoxContainer/Load_Button
@onready var options_button: Button = $CanvasLayer/BoxContainer/Options_Button
@onready var mission_editor: Button = $"CanvasLayer/BoxContainer/Mission Editor"
@onready var exit_button: Button = $CanvasLayer/BoxContainer/Exit_Button


func _ready() -> void:
    #start_button.pressed.connect(
        #func() -> void:
        #get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Node.tscn")
    #)
    load_button.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Load_Map.tscn")
    )
    options_button.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Options.tscn")
    )
    mission_editor.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Mission_Creator.tscn")
    )
    exit_button.pressed.connect(
        func() -> void:
        get_tree().quit(0)
    )
