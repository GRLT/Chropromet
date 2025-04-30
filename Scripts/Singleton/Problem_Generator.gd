extends Node

const TIME_BETWEEN_PROBLEMS = 6
const WARNING_RAID_TIMER = 3


signal chiper(problems: Caesar_Shift_Object)
signal keyboard_layout(layout: String)
signal load_map(data: Array)

var problem_timer := Timer.new()
var signal_setup := Timer.new()


var problems: Array[Object] = []

var layout: Array[String] = ["qwerty", "dvorak", "azerty"]
var radio_type: Array[String] = ["weapon", "medicine", "shell"]

@warning_ignore("unreachable_code")
func _ready() -> void:

    timer_for_problem_gen()
    
    load_map.connect(
        func(data: Array) -> void:
            load_from_file(data)
    )
    #await get_tree().process_frame
    #SignalBus.raid_prep.emit(Raid_Object.new(2, 10, 4))

func timer_for_problem_gen() -> void:
    problem_timer.paused = true
    problem_timer.name = "problem_timer"
    signal_setup.paused = true
    signal_setup.name = "signal_setup"
    
    add_child(problem_timer)
    problem_timer.one_shot = false
    problem_timer.wait_time = TIME_BETWEEN_PROBLEMS
    problem_timer.start(TIME_BETWEEN_PROBLEMS)
    problem_timer.timeout.connect(send_problem)

    add_child(signal_setup)
    signal_setup.one_shot = true
    signal_setup.start(0.1)
    signal_setup.timeout.connect(setup)


    

func load_from_file(data: Array) -> void:
    for i:Object in data:
        if i is Caesar_Shift_Object:
            problems.push_back(i)
        elif i is Morse:
            problems.push_back(i)
        elif i is Raid_Object:
            problems.push_back(i)
        elif i is Logic_Board:
                problems.push_back(i)
            

func setup() -> void:
    keyboard_layout.emit(layout.pick_random())


func send_problem() -> void:
    if problems.size() > 0:
        var current := problems[0]

        if current is Caesar_Shift_Object:
            chiper.emit(current)
            problems.pop_front()
            print("Caesar Shift Signal")

        if current is Raid_Object:
            SignalBus.raid_prep.emit(current)
            problems.pop_front()
            print("Raid Signal")

        if current is Morse:
            SignalBus.morse.emit(current)
            problems.pop_front()
            print("Sending a Morse Signal")
            
        if current is Logic_Board:
            SignalBus.logic_game.emit(current)
            problems.pop_front()
            print("Sending Logic Game Signal")
    else:
        SignalBus.all_signal_sent_out.emit()
