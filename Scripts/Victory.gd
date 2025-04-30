extends Node

@onready var back: Button = $Back

func _ready() -> void:
    back.pressed.connect(
        func() -> void:
            get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Title.tscn")
    )
