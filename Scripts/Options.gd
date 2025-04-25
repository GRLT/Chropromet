extends Control

@onready var scene: Node = get_node(".")

@onready var back: Button = $CanvasLayer/BoxContainer/Back_Button
@onready var save: Button = $CanvasLayer/BoxContainer/Save_Button

@onready var volume_label_value: Label = $CanvasLayer/BoxContainer/HVolume_Container/Volume_Label_Value

@onready var vsync: CheckButton = $CanvasLayer/BoxContainer/HVsync_Container/Vsync_Check
@onready var window_mode: OptionButton = $CanvasLayer/BoxContainer/HWindow_Container/Window_Mode_Option
@onready var max_fps_option: OptionButton = $CanvasLayer/BoxContainer/HFPS_Container/Max_FPS_Option
@onready var volume_slider: HSlider = $CanvasLayer/BoxContainer/HVolume_Container/Volume_Slider


var state_changed:bool = false

func _ready() -> void:
    #Disables the option boxes
    remove_radio_buttons(window_mode)
    remove_radio_buttons(max_fps_option)
    set_default_values()
    
    #Connections
    vsync.toggled.connect(vsync_check_toggled)
    max_fps_option.item_selected.connect(max_fps_item_change)
    window_mode.item_selected.connect(window_mode_item_change)
    volume_slider.value_changed.connect(volume_slider_value_changed)
    back.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Title.tscn"))
    save.pressed.connect(save_pressed)
    
@warning_ignore("unsafe_method_access")
func save_pressed() -> void:
    var alert_win: = preload("res://Scenes/Components/Alert_Window.tscn").instantiate()
    if state_changed:
        alert_win.init("Info", 2)
        scene.add_child(alert_win)
        state_changed = false
    else:
        alert_win.init("Info", 3)
        scene.add_child(alert_win)
        Settings.save_settings(get_values())
        #Reloades the config after changes so if scene changed, everything set correctly
        Settings.load_settings()

func set_default_values() -> void:
    vsync.button_pressed = Settings.vsync
    window_mode.selected = window_mode.get_item_index(Settings.window_mode)
    for i in max_fps_option.item_count:
        if Settings.max_fps == int(max_fps_option.get_item_text(i)):
            max_fps_option.selected = max_fps_option.get_item_id(i)
            continue
            
    volume_slider.value = Settings.volume
    volume_label_value.text = str(int(volume_slider.value)) + '%'

func get_values() -> Array:
    var values:Array = []
    values.append(int(vsync.button_pressed))
    values.append(window_mode.get_selected_id())
    values.append(int(max_fps_option.get_item_text(max_fps_option.selected)))
    values.append(volume_slider.value)
    return values
    
    
#https://www.reddit.com/r/godot/comments/oz45zd/anyway_to_remove_that_radio_button_check_on_the/
func remove_radio_buttons(option_button: OptionButton) -> void:
    var pm: PopupMenu = option_button.get_popup()
    for i in pm.get_item_count():
        if pm.is_item_radio_checkable(i):
            pm.set_item_as_radio_checkable(i, false)

func vsync_check_toggled(state: bool) -> void:
    if state:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    else:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

    state_changed = true
    
func volume_slider_value_changed(value: int) -> void:
    var current_volume: String = str(int(volume_slider.value))

    volume_label_value.text = current_volume + "%"
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), int(current_volume))    

    state_changed = true
    
func max_fps_item_change(id: int) -> void:
    Engine.set_max_fps(int(max_fps_option.get_item_text(id)))
    
    state_changed = true
    
func window_mode_item_change(index: int) -> void:
    var id:int = window_mode.get_item_id(index)
    match id:
        0:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        3:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        4:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    state_changed = true
