extends Control

@onready var exit_button = $CanvasLayer/Exit

func _ready():
	exit_button.pressed.connect(exit_button_pressed)


func exit_button_pressed():
	get_tree().quit()
