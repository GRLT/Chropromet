extends Node2D

#var test_audio = preload("res://Assets/Music/output.mp3")

signal morse_back
signal morse_info(pool_size: int)
signal map_back
signal raid_back
signal radio_back

@onready var warning_texture_on: Resource = load("res://Assets/Raid_Warning_0.png")
@onready var warning_texture_off: Resource = load("res://Assets/Raid_Warning_1.png")
@onready var chiper_station_texture_bool: Resource = load("res://Assets/Raid_Warning_0.png")

@onready var main_node: Node2D = get_node("/root/Main_Node")
@onready var main_game: Node2D = $MainGame

@onready var chiper_view: Control = $Chiper
@onready var chiper_station_counter: Label = $MainGame/Stations/Chiper_Station/Chiper_Station_Counter
@onready var chiper_button: Button = $MainGame/Stations/Chiper_Station/Chiper_Button
@onready var chiper_camera: Camera2D = $Chiper/View

@onready var map: Node2D = $Map
@onready var map_button: Button = $MainGame/Stations/Map_Station/Map_Button
@onready var map_camera: Camera2D = $Map/Map_Camera

@onready var morse: Node2D = $Morse
@onready var morse_button: Button = $MainGame/Stations/Morse_Station/Morse_Button
@onready var morse_camera: Camera2D = $Morse/Morse_Camera

@onready var raid_button: Button = $MainGame/RaidButton
@onready var warning_texture: TextureRect = $MainGame/Warning_Texture
@onready var raid_camera: Camera2D = $Raid_s/RaidCamera
@onready var raid_s: Node2D = $Raid_s

#ALERT Moronic fix for compilation error
@onready var warning_buttons: Array[TextureRect] = Array_Node_to_Array_TextureRect(
    get_tree().get_nodes_in_group("warning")
)


func Array_Node_to_Array_TextureRect(nodes: Array[Node]) -> Array[TextureRect]:
    var accu: Array[TextureRect] = []
    for elem in nodes:
        if elem is TextureRect:
            accu.append(elem)

    return accu


var switcher: Timer = Timer.new()


func _ready() -> void:
    chiper_button.pressed.connect(chiper_button_pressed)
    map_button.pressed.connect(map_button_pressed)
    raid_button.pressed.connect(raid_button_pressed)
    morse_button.pressed.connect(morse_button_pressed)
    #This is disgusting, either factor them out, into a var or always use this casting method
    ($MainGame/RuleBook as Button).pressed.connect(rulebook_button_pressed)
    ($MainGame/GameStart as Button).pressed.connect(gamestart_button_pressed)
    ($MainGame/Stations/Radio_Station/Radio_Button as Button).pressed.connect(radio_button_pressed)

    morse_back.connect(morse_back_callback)
    morse_info.connect(morse_info_callback)
    map_back.connect(map_back_callback)
    raid_back.connect(raid_button_back)
    radio_back.connect(radio_back_callback)

    ProblemGenerator.connect("warning_raid", warning_raid)
    chiper_view.connect("radio_info", radio_info)
    chiper_view.connect("chiper_back", chiper_back)
    ($Book as Window).hide()
    add_child(switcher)


func morse_info_callback(pool_size: int) -> void:
    ($MainGame/Stations/Morse_Station/Morse_Station_Counter as Label).text = str(pool_size)


func gamestart_button_pressed() -> void:
    ProblemGenerator.problem_timer.paused = false
    ProblemGenerator.signal_setup.paused = false
    ProblemGenerator.raid_timer.paused = false
    $MainGame/GameStart.queue_free()


func morse_back_callback() -> void:
    hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map", "Morse"])


func map_back_callback() -> void:
    hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map"])

func rulebook_button_pressed() -> void:
    var book: Book = $Book
    print(book.visible)
    if book.visible:
        book.visible = true
    else:
        book.visible = false


func map_button_pressed() -> void:
    hide_unhide_with_expection(true, ["Map"])
    map_camera.make_current()

    
func warning_raid(toggle: bool) -> void:
    if toggle:
        switcher.paused = false
        switcher.one_shot = false
        switcher.start(0.15)
        switcher.timeout.connect(warning_switcher)
    else:
        switcher.paused = true
        warning_texture.texture = warning_texture_on


func warning_switcher(toggle: bool) -> void:
    for i in warning_buttons:
        if toggle:
            i.texture = warning_texture_off
            toggle = false
        else:
            i.texture = warning_texture_on
            toggle = true


@warning_ignore("unsafe_property_access")


func hide_unhide_all_station(hide_obj: bool) -> void:
    for i in main_node.get_children():
        i.visible = hide_obj


# True Unhides && False Hides
#ALERT
# Should return bool for failcheck
@warning_ignore("unsafe_property_access")


func hide_unhide_with_expection(hide_obj: bool, exepction_array: Array[String]) -> void:
    var found: bool = false
    for i in main_node.get_children():
        for j in exepction_array:
            if i.name == j && hide_obj:
                i.visible = true
                found = true
            elif i.name == j && !hide_obj:
                i.visible = false
                found = true
        if found:
            continue
        if hide_obj:
            i.visible = false
        else:
            i.visible = true


func disable_main_buttons(hide: bool) -> void:
    for i: Button in get_tree().get_nodes_in_group("main_buttons"):
        if hide:
            i.disabled = hide
        else:
            i.disabled = false


func radio_info(problem_queue_size: int, active: bool) -> void:
    chiper_station_counter.text = str(problem_queue_size)
    #radio_station_bool.texture = chiper_station_texture_bool


func radio_back_callback() -> void:
    hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map", "Morse", "RadioView"])


func radio_button_pressed() -> void:
    hide_unhide_with_expection(true, ["RadioView"])
    ($RadioView/Radio_Camera as Camera2D).make_current()


func morse_button_pressed() -> void:
    hide_unhide_with_expection(true, ["Morse"])
    morse_camera.make_current()
    ($Morse/SoundPlayer as AudioStreamPlayer).set_volume_db(0)


func raid_button_pressed() -> void:
    hide_unhide_with_expection(true, ["Raid_s"])
    raid_camera.make_current()


func raid_button_back() -> void:
    hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map", "Morse", "RadioView"])


func chiper_back() -> void:
    hide_unhide_with_expection(false, ["Raid_s", "Chiper", "Map", "Morse", "RadioView"])


func chiper_button_pressed() -> void:
    hide_unhide_with_expection(true, ["Chiper"])
    chiper_camera.make_current()
