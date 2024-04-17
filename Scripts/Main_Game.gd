extends Node2D

@onready var main_game = get_node(".")

@onready var chiper_button = $Chiper_Button
@onready var chiper_radio_view = $ChiperRadioView
@onready var chiper_radio_camera = $ChiperRadioView/View

func _ready():
	chiper_button.pressed.connect(chiper_button_pressed)


func chiper_button_pressed():
	chiper_radio_camera.make_current()
