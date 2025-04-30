extends Node2D

signal morse_info(pool_size: int)

@onready var main_node: Node2D = get_node("/root/Main_Node")
@onready var main_game: Node2D = $MainGame
@onready var main_camera: Camera2D = $MainGame/Main_Camera

@onready var chiper_button: Button = $MainGame/HBoxContainer/Chiper_Button
@onready var chiper_camera: Camera2D = $Chiper/View

@onready var morse_button: Button = $MainGame/HBoxContainer/Morse_Button
@onready var morse_camera: Camera2D = $Morse/Morse_Camera

@onready var raid_button: Button = $MainGame/HBoxContainer/RaidButton
@onready var raid_camera: Camera2D = $Raid_s/RaidCamera

@onready var logic_gate_camera: Camera2D = $StaticBoolGame/LogicGameCamera
@onready var logic_gate_button: Button = $MainGame/HBoxContainer/Logic_Gate

@onready var complete_timer: Timer = Timer.new()

@onready var rulebook_button: Button = $MainGame/RuleBook_Button
var rulebook := preload("res://Scenes/Components/book.tscn")

@onready var active_containre: HBoxContainer = $MainGame/HBoxContainer
@onready var active_logic_gate_label : Label = $MainGame/Active_Container/LogicGate
@onready var active_morse_label : Label = $MainGame/Active_Container/LogicGate
@onready var active_chiper_game_label : Label = $MainGame/Active_Container/LogicGate


var logic_complete:bool = false
var all_signal_sent_out_var:bool = false
var chiper_complete_var:bool = false
var morse_complete_var:bool = false
func logic_gate_complete() -> void:
    logic_complete = true   
    
func all_signal_sent_out() -> void:
    all_signal_sent_out_var = true

func chiper_complete() -> void:
    chiper_complete_var = true

func morse_complete() -> void:
    morse_complete_var = true

func signal_setup() -> void:
    complete_timer.one_shot = false
    main_game.add_child(complete_timer)
    complete_timer.wait_time = 5
    
    complete_timer.timeout.connect(
        func() -> void:
            #print(logic_complete, all_signal_sent_out_var, chiper_complete_var, morse_complete_var)
            if logic_complete && all_signal_sent_out_var && chiper_complete_var && morse_complete_var:
                get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Victory.tscn")

            
            logic_complete = false
            all_signal_sent_out_var = false
            chiper_complete_var = false
            morse_complete_var = false
    )

    SignalBus.logic_gate_complete.connect(logic_gate_complete)
    SignalBus.all_signal_sent_out.connect(all_signal_sent_out)
    SignalBus.chiper_complete.connect(chiper_complete)
    SignalBus.morse_complete.connect(morse_complete)
    
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
            ($Morse/SoundPlayer as AudioStreamPlayer).set_volume_db(-15)
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
    complete_timer.start(5)
    ProblemGenerator.problem_timer.paused = false
    ProblemGenerator.signal_setup.paused = false
    $MainGame/GameStart.queue_free()




    
