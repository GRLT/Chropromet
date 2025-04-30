extends Node2D

signal morse_info(pool_size: int)

@onready var main_node: Node2D = get_node("/root/Main_Node")
@onready var main_game: Node2D = $MainGame
@onready var main_camera: Camera2D = $MainGame/Main_Camera

@onready var chiper_station_counter: Label = $MainGame/Stations/Chiper_Station/Chiper_Station_Counter
@onready var chiper_button: Button = $MainGame/Stations/Chiper_Station/Chiper_Button
@onready var chiper_camera: Camera2D = $Chiper/View

@onready var morse_button: Button = $MainGame/Stations/Morse_Station/Morse_Button
@onready var morse_camera: Camera2D = $Morse/Morse_Camera

@onready var raid_button: Button = $MainGame/RaidButton
@onready var raid_camera: Camera2D = $Raid_s/RaidCamera

@onready var logic_gate_camera: Camera2D = $StaticBoolGame/LogicGameCamera
@onready var logic_gate_button: Button = $MainGame/Stations/Logic_Gate_Station/Logic_Gate

@onready var rulebook_button: Button = $MainGame/RuleBook_Button
var rulebook := preload("res://Scenes/Components/book.tscn")

func signal_setup() -> void:
    raid_button.pressed.connect(
        func() -> void:
        raid_camera.make_current()
    )
    
    chiper_button.pressed.connect(
        func() -> void:
        chiper_camera.make_current()
    )
    
    morse_button.pressed.connect(
        func() -> void:
            morse_camera.make_current()
            ($Morse/SoundPlayer as AudioStreamPlayer).set_volume_db(-5)
    )
    
    logic_gate_button.pressed.connect(
        func() -> void:
            logic_gate_camera.make_current()
    )
    
    rulebook_button.pressed.connect(
        func() -> void:
                main_game.add_child(rulebook.instantiate())
                var exception:Array[String] = ["Main", "Raid"]
                SignalBus.hide_book_pages_with_exception.emit(exception)
    )
    
    
    SignalBus.scene_to_main.connect(
        func() -> void:
            main_camera.make_current()
    )

func _ready() -> void:
    signal_setup()
    


    ($MainGame/GameStart as Button).pressed.connect(gamestart_button_pressed)

    morse_info.connect(
        func(pool_size: Variant) -> void:
            ($MainGame/Stations/Morse_Station/Morse_Station_Counter as Label).text = str(pool_size)
    )

func gamestart_button_pressed() -> void:
    ProblemGenerator.problem_timer.paused = false
    ProblemGenerator.signal_setup.paused = false
    $MainGame/GameStart.queue_free()


func radio_info(problem_queue_size: int, active: bool) -> void:
    chiper_station_counter.text = str(problem_queue_size)


    
