extends Node

const TIME_BETWEEN_PROBLEMS = 5 
const WARNING_RAID_TIMER = 3


signal chiper(problems: Caesar_Shift_Object)
signal keyboard_layout(layout: String)
signal raid()
signal morse(morse_object: Morse)
signal load_map(data: Array)

var problem_timer := Timer.new()
var signal_setup := Timer.new()




var problems: Array[Object] = []

var layout: Array[String] = ["qwerty", "dvorak", "azerty"]
var radio_type: Array[String] = ["weapon", "medicine", "shell"]

@warning_ignore("unreachable_code")
func _ready() -> void:
    # TODO
    # DELETE_ME, this is just to remove junk while 
    # creating new stuff, but maybe this is just 
    # neat, and I should leave it here
    #var root := get_node("../Main_Node")

    timer_for_problem_gen()
    
    load_map.connect(
        func(data: Array) -> void:
            load_from_file(data)
    )
        

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


    

@warning_ignore("untyped_declaration", "unsafe_method_access")
func load_from_file(data: Array) -> void:
    for i in data:
        if i is Caesar_Shift_Object:
            chiper_message(i.getMessage() as String, i.getShift() as int)
        elif i is Morse:
            morse_message(i.getMessage() as String, i.getDuration() as int)

func raid_prep(raid_start: float, duration: float) -> void:
    var raid_obj: Raid_Object = Raid_Object.new(raid_start, duration)
    problems.push_back(raid_obj)


func supply_drop(x: int, y: int, type: String) -> void:
    var supply_drop_obj := Supply_Drop.new(x, y, type)
    problems.push_back(supply_drop_obj)

#shift max range -24 to 24
func chiper_message(message: String, shift: int) -> void:
    #var chiper_random = randi_range(-24, 24)
    var chiper_obj := Caesar_Shift_Object.new(message, shift)
    problems.push_back(chiper_obj)


func morse_message(message: String, duration: int) -> void:
    var morse_obj := Morse.new(message, duration)
    problems.push_back(morse_obj)


func raid_timer_timeout(duration: float) -> void:
    if emit_signal("active_raid", duration) == ERR_UNAVAILABLE:
        push_warning("Failed to send active_raid signal!")


func setup() -> void:
    keyboard_layout.emit(layout.pick_random())


func send_problem() -> void:
    print(problems)
    if problems.size() > 0:
        var current := problems[0]
        print("Sending current problem: ", current)
        if current is Caesar_Shift_Object:
            chiper.emit(current)
            problems.pop_front()

        if current is Raid_Object:
            var current_Raid_Object: Raid_Object = current
            #Just send a signal and let raid singelton handle it 
            raid.emit()
            #raid_send(current_Raid_Object.getRaidStart(), current_Raid_Object.getDuration())
            problems.pop_front()


        if current is Morse:
            morse.emit(current as Morse)
            print("Sending a Morse Signal.")
            problems.pop_front()
