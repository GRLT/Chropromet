extends Control

@onready
var window_mode_option: OptionButton = $CanvasLayer/BoxContainer/HWindow_Container/Window_Mode_Option

@onready var back: Button = $CanvasLayer/BoxContainer/Back_Button

@onready var volume_slider: HSlider = $CanvasLayer/BoxContainer/HVolume_Container/Volume_Slider
@onready
var volume_label_value: Label = $CanvasLayer/BoxContainer/HVolume_Container/Volume_Label_Value

@onready var max_fps_label: Label = $CanvasLayer/BoxContainer/HFPS_Container/Max_FPS_Label
@onready var max_fps_option: OptionButton = $CanvasLayer/BoxContainer/HFPS_Container/Max_FPS_Option

@onready var vsync_check: CheckButton = $CanvasLayer/BoxContainer/HVsync_Container/Vsync_Check

#Keybindings


func _ready() -> void:
	#Disables the option boxes
	make_option_button_items_non_radio_checkable(window_mode_option)
	make_option_button_items_non_radio_checkable(max_fps_option)

	#Sets Max_FPS_Option's system default value
	set_default_values()

	#Connections
	vsync_check.toggled.connect(vsync_check_toggled)
	max_fps_option.item_selected.connect(max_fps_item_change)
	window_mode_option.item_selected.connect(window_mode_item_change)
	volume_slider.value_changed.connect(volume_slider_value_changed)
	back.pressed.connect(back_button_pressed)


func set_default_values() -> void:
	for i in max_fps_option.get_item_count():
		if max_fps_option.get_item_text(i) == str(ceil(DisplayServer.screen_get_refresh_rate())):
			max_fps_option.selected = i
			continue
	window_mode_option.selected = window_mode_option.get_item_index(DisplayServer.window_get_mode())
	vsync_check.set_pressed(DisplayServer.window_get_vsync_mode())
	Engine.set_max_fps(DisplayServer.screen_get_refresh_rate())
	volume_label_value.text = str(int(volume_slider.value)) + "%"


#https://www.reddit.com/r/godot/comments/oz45zd/anyway_to_remove_that_radio_button_check_on_the/
func make_option_button_items_non_radio_checkable(option_button: OptionButton) -> void:
	var pm: PopupMenu = option_button.get_popup()
	for i in pm.get_item_count():
		if pm.is_item_radio_checkable(i):
			pm.set_item_as_radio_checkable(i, false)


func vsync_check_toggled(state: bool) -> void:
	if state:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func volume_slider_value_changed(value: int) -> void:
	var current_volume: String = str(int(volume_slider.value))

	volume_label_value.text = current_volume + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), int(current_volume))


func back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Title.tscn")


func max_fps_item_change(id: int) -> void:
	Engine.set_max_fps(int(max_fps_option.get_item_text(id)))


func window_mode_item_change(id: int) -> void:
	match id:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
