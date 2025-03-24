extends Node2D

@onready var raid := get_node(".")

@onready var main_camera: Camera2D = get_node("/root/Main_Node/MainGame/Main_Camera")

@onready var back: Button = $Back

var raid_timer := Timer.new()
var check_raid := Timer.new()

signal raid_back


func _ready() -> void:
	back.pressed.connect(on_back_pressed)
	ProblemGenerator.active_raid.connect(raid_check)

	add_child(raid_timer)
	add_child(check_raid)


func raid_check(duration: float) -> void:
	raid_timer.start(duration)
	raid_timer.one_shot = true
	if !is_connected("timeout", raid_end):
		raid_timer.timeout.connect(raid_end)
	if raid_timer.time_left != 0:
		check_raid.start(0.1)
		if !is_connected("timeout", check_current_raid):
			check_raid.timeout.connect(check_current_raid)


func raid_end() -> void:
	($Status as Label).text = "Raid Over!"
	check_raid.stop()


func check_current_raid() -> void:
	($Status as Label).text = "RAID!"
	var current_camera: String = get_viewport().get_camera_2d().name
	if current_camera != "RaidCamera":
		get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Fail.tscn")
	else:
		print("Good to go, player looking at the")


func on_back_pressed() -> void:
	main_camera.make_current()
	raid_back.emit()
