extends Node

@onready var fail0:TextureRect = $TextureRect/VBoxContainer/HBoxContainer/Fail0
@onready var fail1:TextureRect = $TextureRect/VBoxContainer/HBoxContainer/Fail1
@onready var fail2:TextureRect = $TextureRect/VBoxContainer/HBoxContainer/Fail2

var counter:int = 0
func _ready() -> void:
    SignalBus.fail_points.connect(
        func() -> void:
            
            if counter == 0:
                fail0.visible = true
            if counter == 1:
                fail1.visible = true
            if counter == 2:
                get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Fail.tscn")
            
            counter += 1
    )
