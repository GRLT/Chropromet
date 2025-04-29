extends Node

@onready var display: RichTextLabel = $Chiper_Display
@onready var fail: Timer = $Timeout_Timer
@onready var charachter_timeout: Timer = $Charachter_Timer
@onready var scence_back: Button = $Back

@onready var submit_button: Button = $Keyboard/Submit
@onready var player_input_screen: Label = $Keyboard/Player_Input_Screen
@onready var keyboard: Keyboard = $Keyboard

@onready var main_game := get_node("..")

var problem_queue: Array[Caesar_Shift_Object] = []

signal stat
signal radio_info
signal chiper_back

const SEQUENCE_START = "/"


func _ready() -> void:
    ProblemGenerator.connect("chiper", arrive_chiper)
    ProblemGenerator.connect("active_raid", raid)
    
    scence_back.pressed.connect(
        func() -> void:
        var main_scene: Node2D = get_node("/root/Main_Node/MainGame")
        if main_scene != null:
            (main_scene.get_node("Main_Camera") as Camera2D).make_current()
        chiper_back.emit()
    )
    
    charachter_timeout.timeout.connect(message_print)
    submit_button.pressed.connect(check_chiper)






func arrive_chiper(problems: Caesar_Shift_Object = null) -> void:
    problem_queue.append(problems)

    charachter_timeout.start()


var active := false


func send_view_info() -> void:
    radio_info.emit(problem_queue.size(), active)


var char_counter: int = 0


func message_print() -> void:
    var current_queue: Caesar_Shift_Object

    send_view_info()
    active = true

    if problem_queue.size() != 0:
        current_queue = problem_queue[0]

        if current_queue == null:
            return

        if char_counter == 0:
            display.text = SEQUENCE_START
            char_counter += 1
            return

        if char_counter < current_queue.getEncrypted().length():
            display.text = str(current_queue.getEncrypted()[char_counter])
            char_counter += 1
        elif fail.time_left == 0:
            char_counter = 0
            fail.start()
            if !fail.is_connected("timeout", check_chiper):
                fail.connect("timeout", check_chiper)
        else:
            char_counter = 0


func check_chiper() -> void:
    if problem_queue.size() > 0:
        if player_input_screen.text == problem_queue[0].getMessage():
            player_input_screen.text = ""
            problem_queue.pop_front()
            print("Entered success")
            timers_stop()

            display.text = "SUCCESS!"
        else:
            timers_stop()
            player_input_screen.text = ""
            print("Entered fail")
            if problem_queue.size() != 0:
                problem_queue.pop_front()
                display.text = "FAIL"
                active = false
                arrive_chiper()
                #Send back a signal with fail
                stat.emit()
    else:
        player_input_screen.text = "FAIL"


func timers_stop() -> void:
    fail.stop()
    charachter_timeout.stop()


## True = pause    ||   False = unpause
func timer_pause_or_resume(toggle: bool) -> void:
    fail.set_paused(toggle)
    charachter_timeout.set_paused(toggle)


#Stop the timer while a raid is ongoing.
func raid(duration: float) -> void:
    timer_pause_or_resume(true)

    var countdown := Timer.new()
    add_child(countdown)
    countdown.one_shot = true
    countdown.start(duration)
    countdown.timeout.connect(countdown_end)


func countdown_end() -> void:
    timer_pause_or_resume(false)

#TODO
#Indicate when switching between charachters, It's really hard
#to see the difference between (ebiil tloia) when the two i / i next to eachother
#blink anmiation?
#"corrupted" animation?
# Charachter fadeing time and logic
