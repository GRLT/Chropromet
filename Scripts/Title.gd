extends Control

@onready var start_button := $CanvasLayer/VBoxContainer/Start_Button
@onready var options_button := $CanvasLayer/VBoxContainer/Options_Button
@onready var exit_button := $CanvasLayer/VBoxContainer/Exit_Button


func _ready():
	start_button.pressed.connect(start_button_pressed)
	options_button.pressed.connect(options_button_pressed)
	exit_button.pressed.connect(exit_button_pressed)


func start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Node.tscn")
	ProblemGenerator.problem_timer.paused = false
	ProblemGenerator.signal_setup.paused = false
	ProblemGenerator.raid_timer.paused = false
	
	
func options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Options.tscn")

func exit_button_pressed():
	get_tree().quit(0)
