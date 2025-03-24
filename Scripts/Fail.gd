extends Control

@onready var exit_button: Button = $CanvasLayer/Exit


func _ready() -> void:
    exit_button.pressed.connect(exit_button_pressed)


func exit_button_pressed() -> void:
    get_tree().quit()
