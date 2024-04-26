extends Node2D

@onready var raid = get_node(".")

@onready var main_camera:Camera2D = get_node("/root/Main_Node/MainGame/Main_Camera")

@onready var back = $Back

var raid_timer := Timer.new()
var check_raid := Timer.new()

signal raid_back

func _ready():
	back.pressed.connect(on_back_pressed)
	ProblemGenerator.active_raid.connect(raid_check)
	
	add_child(raid_timer)
	add_child(check_raid)

	

func raid_check(duration):
	raid_timer.start(duration)
	raid_timer.one_shot = true
	raid_timer.timeout.connect(raid_end)
	
	if raid_timer.time_left != 0:
		check_raid.start(0.1)
		check_raid.timeout.connect(check_current_raid)
	

func raid_end():
	check_raid.stop()

func check_current_raid():
	var current_camera = get_viewport().get_camera_2d().name
	if current_camera != "RaidCamera":
		#Transition into fail
		print("Fail state")
		#get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Game.tscn")
	else:
		print("Good to go, player looking at the")
		

func on_back_pressed():
	main_camera.make_current()
	
	if emit_signal("raid_back") == ERR_UNAVAILABLE:
		print("Failed to raid_back signal")
