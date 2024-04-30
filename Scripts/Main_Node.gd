extends Node2D

var test_audio = preload("res://Assets/Music/output.mp3")
@onready var audio_player = $AudioStreamPlayer2D

@onready var texture_test = load("res://Assets/Raid_Warning_0.png")
@onready var texture_test2 = load("res://Assets/Raid_Warning_1.png")

@onready var main_node = get_node("/root/Main_Node")
@onready var main_game = $MainGame

@onready var radio_view = $ChiperRadioView
@onready var radio_station = $MainGame/Radio_Station
@onready var radio_station_counter = $MainGame/Radio_Station/Chiper_Station_Counter

@onready var chiper_button = $MainGame/Radio_Station/Chiper_Button
@onready var chiper_radio_camera = $ChiperRadioView/View

@onready var raid_button = $MainGame/RaidButton
@onready var raid_camera = $Raid_s/RaidCamera
@onready var raid_s = $Raid_s

var switcher := Timer.new()

func _ready():
	audio_player.stream = test_audio
	audio_player.play()
	
	chiper_button.pressed.connect(chiper_button_pressed)
	raid_button.pressed.connect(raid_button_pressed)
	raid_s.raid_back.connect(raid_button_back)
	ProblemGenerator.connect("warning_raid", warning_raid)

	radio_view.connect("radio_info", radio_info)
	radio_view.connect("chiper_back", chiper_back)

	add_child(switcher)

func warning_raid(toggle):
	print(toggle)
	if toggle:
		switcher.paused = false
		switcher.one_shot = false
		switcher.start(0.15)
		switcher.timeout.connect(warning_switcher)
	else:
		switcher.paused = true
		$MainGame/TextureRect.texture = texture_test

var toggle = true
func warning_switcher():
	if toggle:
		print("Texture1")
		$MainGame/TextureRect.texture = texture_test
		$ChiperRadioView/TextureRect.texture = texture_test
		toggle = false
	else:
		print("Texture2")
		$MainGame/TextureRect.texture = texture_test2
		$ChiperRadioView/TextureRect.texture = texture_test2
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
	#print("Arrived from Radio_View with the size of ", problem_queue_size, " and with the state of ", active)
	radio_station_counter.text = str(problem_queue_size)

func raid_button_pressed():
	hide_unhide_with_expection(true, ["Raid_s"])
	raid_camera.make_current()
	
	#hide_unhide_all_station(false)
	#get_node("Raid_s").visible = true

func raid_button_back():
	hide_unhide_with_expection(false, ["Raid_s", "ChiperRadioView"])

func chiper_back():
	hide_unhide_with_expection(false, ["ChiperRadioView"])

func chiper_button_pressed():
	hide_unhide_with_expection(true, ["ChiperRadioView"])
	chiper_radio_camera.make_current()
