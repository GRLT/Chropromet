extends Node

@onready var display: RichTextLabel = $Chiper_Display
@onready var fail: Timer = $Timeout_Timer
@onready var charachter_timeout: Timer = $Charachter_Timer
@onready var back: Button = $Back
@onready var scene:Node2D = $"."
@onready var check_timer: Timer = Timer.new()

@onready var submit_button: Button = $Keyboard/Submit
@onready var player_input_screen: Label = $Keyboard/Player_Input_Screen
@onready var keyboard: Keyboard = $Keyboard

@onready var rulebook_button: Button = $RuleBook_Button
var rulebook := preload("res://Scenes/Components/book.tscn")

var problem_queue: Array[Caesar_Shift_Object] = []

signal radio_info
signal chiper_back


func _ready() -> void:
    ProblemGenerator.connect("chiper", arrive_chiper)

    check_timer.one_shot = false
    scene.add_child(check_timer)
    check_timer.start(1)
    
    check_timer.timeout.connect(
        func() -> void:
            if message_active ==false && problem_queue.size() == 0 && current_queue == null:
                SignalBus.chiper_complete.emit()
    )
    
    back.pressed.connect(
        func() -> void:
            SignalBus.scene_to_main.emit()
    )
    charachter_timeout.timeout.connect(message_print)
    submit_button.pressed.connect(check_chiper)

    rulebook_button.pressed.connect(
        func() -> void:
                scene.add_child(rulebook.instantiate())
                var exception:Array[String] = ["Chiper Game"]
                SignalBus.hide_book_pages_with_exception.emit(exception)
    )


func arrive_chiper(problems: Caesar_Shift_Object = null) -> void:
    problem_queue.append(problems)
    charachter_timeout.start()
    

var message_active: bool = false
var char_counter: int = 0
var current_queue: Caesar_Shift_Object
func message_print() -> void:


    message_active = true

    if problem_queue.size() != 0:
        current_queue = problem_queue[0]

        if current_queue == null:
            return
#
        
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
                charachter_timeout.start()
                problem_queue.pop_front()
                SignalBus.fail_points.emit()
                display.text = "FAIL"
                message_active = false
                arrive_chiper()
                #Send back a signal with fail
    #else:
        #player_input_screen.text = "FAIL"
        


func timers_stop() -> void:
    fail.stop()
    charachter_timeout.stop()


## True = pause    ||   False = unpause
func timer_pause_or_resume(toggle: bool) -> void:
    fail.set_paused(toggle)
    charachter_timeout.set_paused(toggle)


#TODO
#Indicate when switching between charachters, It's really hard
#to see the difference between (ebiil tloia) when the two i / i next to eachother
#blink anmiation?
#"corrupted" animation?
# Charachter fadeing time and logic
