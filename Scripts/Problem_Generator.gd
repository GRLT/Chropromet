extends Node

#Each day(maps) should have different instructions with different time
#between instructions. This should be the game.
#

const TIME_BETWEEN_PROBLEMS = 1
const WARNING_RAID_TIMER = 3


signal chiper(problems: Caesar_Shift_Object)
signal keyboard_layout(layout: String)
@warning_ignore("unused_signal")
signal active_raid(duration: float)
@warning_ignore("unused_signal")
signal warning_raid(toggle: bool)
signal supply_drop_signal(supply_object: Supply_Drop)
signal morse(morse_object: Morse)

var problem_timer := Timer.new()
var signal_setup := Timer.new()
var raid_timer := Timer.new()
var warning_raid_timer := Timer.new()
var problems: Array[Object] = []

var layout: Array[String] = ["qwerty", "dvorak", "azerty"]
var radio_type: Array[String] = ["weapon", "medicine", "shell"]


func _ready() -> void:
    problem_timer.paused = true
    signal_setup.paused = true
    raid_timer.paused = true

    add_child(problem_timer)
    problem_timer.one_shot = false
    problem_timer.start(TIME_BETWEEN_PROBLEMS)
    problem_timer.timeout.connect(on_problem_timer_timeout)

    add_child(signal_setup)
    signal_setup.one_shot = true
    signal_setup.start(0.1)
    signal_setup.timeout.connect(setup)

    add_child(raid_timer)
    add_child(warning_raid_timer)

    #morse_message("s", 20)

    chiper_message("f")
    #chiper_message("y")
    #Maybe use a timer for duration and if not fail with it?!
    #supply_drop(5, 6, radio_type[0])
    #supply_drop(4, 3, radio_type[1])
    #chiper_message("q")
    #raid_prep(4,2)
    #chiper_message("message")


func raid_send(raid_start: float, duration: float) -> void:
    if emit_signal("warning_raid", true) == ERR_UNAVAILABLE:
        push_warning("Failed to send warning_raid signal!")
    warning_raid_timer.one_shot = true
    warning_raid_timer.start(WARNING_RAID_TIMER)
    warning_raid_timer.timeout.connect(warning_timer_timeout.bind(raid_start, duration))


#WARNING
#Not really used everywhere
func warning_timer_timeout(raid_start: float, duration: float) -> void:
    if emit_signal("warning_raid", false) == ERR_UNAVAILABLE:
        push_warning("Failed to send warning_raid signal!")
    #print("3 second passed")
    raid_timer.one_shot = true
    raid_timer.start(raid_start)
    raid_timer.timeout.connect(raid_timer_timeout.bind(duration))


func raid_prep(raid_start: float, duration: float) -> void:
    var raid_obj: Raid_Object = Raid_Object.new(raid_start, duration)
    problems.push_back(raid_obj)


func supply_drop(x: int, y: int, type: String) -> void:
    var supply_drop_obj := Supply_Drop.new(x, y, type)
    problems.push_back(supply_drop_obj)


func chiper_message(message: String) -> void:
    #var chiper_random = randi_range(-24, 24)
    var chiper_obj := Caesar_Shift_Object.new(message, 20)
    problems.push_back(chiper_obj)


func morse_message(message: String, duration: int) -> void:
    var morse_obj := Morse.new(message, duration)
    problems.push_back(morse_obj)


func raid_timer_timeout(duration: float) -> void:
    if emit_signal("active_raid", duration) == ERR_UNAVAILABLE:
        push_warning("Failed to send active_raid signal!")


func setup() -> void:
    keyboard_layout.emit(layout.pick_random())


func on_problem_timer_timeout() -> void:
    print(problems)
    if problems.size() > 0:
        var current := problems[0]
        if current is Caesar_Shift_Object:
            chiper.emit(current)
            problems.pop_front()

        if current is Raid_Object:
            var current_Raid_Object: Raid_Object = current
            raid_send(current_Raid_Object.getRaidStart(), current_Raid_Object.getDuration())
            problems.pop_front()

        if current is Supply_Drop:
            supply_drop_signal.emit(current)
            problems.pop_front()

        if current is Morse:
            morse.emit(current)
            print("Sending a Morse Signal.")
            problems.pop_front()
