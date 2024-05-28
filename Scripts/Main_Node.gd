extends Node2D

#var test_audio = preload("res://Assets/Music/output.mp3")
@onready var audio_player = $AudioStreamPlayer2D

@onready var warning_texture_on = load("res://Assets/Raid_Warning_0.png")
@onready var warning_texture_off = load("res://Assets/Raid_Warning_1.png")
@onready var chiper_station_texture_bool = load("res://Assets/Raid_Warning_0.png")

@onready var main_node = get_node("/root/Main_Node")
@onready var main_game = $MainGame

@onready var chiper_view = $Chiper
@onready var chiper_station_counter = $MainGame/Stations/Chiper_Station/Chiper_Station_Counter
@onready var chiper_button = $MainGame/Stations/Chiper_Station/Chiper_Button
@onready var chiper_camera = $Chiper/View

@onready var map = $Map
@onready var map_button = $MainGame/Stations/Map_Station/Map_Button
@onready var map_camera = $Map/Map_Camera

@onready var raid_button = $MainGame/RaidButton
@onready var warning_texture = $MainGame/Warning_Texture
@onready var raid_camera = $Raid_s/RaidCamera
@onready var raid_s = $Raid_s

var switcher := Timer.new()

func _ready():
	chiper_button.pressed.connect(chiper_button_pressed)
	
	map_button.pressed.connect(map_button_pressed)
	map.connect("map_back", map_back)
	
	raid_button.pressed.connect(raid_button_pressed)
	raid_s.raid_back.connect(raid_button_back)

	ProblemGenerator.connect("warning_raid", warning_raid)
	chiper_view.connect("radio_info", radio_info)
	chiper_view.connect("chiper_back", chiper_back)

	add_child(switcher)

func map_back():
	hide_unhide_with_expection(false, ["Raid_s", "ChiperRadioView", "Map"])

func map_button_pressed():
	hide_unhide_with_expection(true, ["Map"])
	map_camera.make_current()

func warning_raid(toggle):
	print(toggle)
	if toggle:
		switcher.paused = false
		switcher.one_shot = false
		switcher.start(0.15)
		switcher.timeout.connect(warning_switcher)
	else:
		switcher.paused = true
		warning_texture.texture = warning_texture_on

var toggle = true
func warning_switcher():	
	if toggle:
		warning_texture.texture = warning_texture_on
		toggle = false
	else:
		warning_texture.texture = warning_texture_off
		toggle = true

func hide_unhide_all_station(hide: bool):
	for i in main_node.get_children():
		i.visible = hide

## True Unhides && False Hides
func hide_unhide_with_expection(hide ,exepction_array: Array[String]):
	var found: bool = false
	for i in main_node.get_children():
		for j in exepction_array:
			if i.name == j && hide:
				i.visible = true
				found = true
			elif i.name == j && !hide:
				i.visible = false
				found = true
		if found:
			continue
		if hide:
			i.visible = false
		else:
			i.visible = true

func disable_main_buttons(hide: bool):
	for i:Button in get_tree().get_nodes_in_group("main_buttons"):
		if hide: 
			i.disabled = hide
		else:
			i.disabled = false
	
func radio_info(problem_queue_size: int, active:bool):
	chiper_station_counter.text = str(problem_queue_size)
	#radio_station_bool.texture = chiper_station_texture_bool 

func raid_button_pressed():
	hide_unhide_with_expection(true, ["Raid_s"])
	raid_camera.make_current()
	

func raid_button_back():
	hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map"])

func chiper_back():
	hide_unhide_with_expection(false, ["Chiper"])

func chiper_button_pressed():
	hide_unhide_with_expection(true, ["Chiper"])
	chiper_camera.make_current()
