#BUFFER_LEN SET TO MAX

extends Node

signal morse_back
signal morse_info(pool_size: int)

var raid_timer := Timer.new()
@onready var back: Button = $Back

#Limit the length beacuse the AudioStreamGenerator buffer dies
#Either incrase the buffer size or keep it in range (~450<)
const LENGTH = 300
enum morse_type { DOT = 1, DASH = 2, EMPTY = 3, CHAR_SEP = 4, WORD_SEP = 5 }
#Spaces between the dot/dash are hardcoded
#https://morsecode.world/international/morse2.html (DOUBLE CHECK!)
enum char_to_morse {
    # dot = 1
    # dash = 2
    a = 12,
    b = 2111,
    c = 2121,
    d = 211,
    e = 1,
    f = 1121,
    g = 221,
    h = 1111,
    i = 11,
    j = 1222,
    k = 212,
    l = 1211,
    m = 22,
    n = 21,
    o = 222,
    p = 1221,
    q = 2212,
    r = 121,
    s = 111,
    t = 2,
    u = 112,
    v = 1112,
    w = 122,
    x = 2112,
    y = 2122,
    z = 2211,
}

#Be carefull don't use high sample rate
var sample_hz: float = 1000.0
var pulse_hz: float = 450.0
var phase: float = 0.0
var playback: AudioStreamGeneratorPlayback = null
var morse_code: Array = []
var morse_code_buf: Array = []
var morse_problem_buf := []

var timer := Timer.new()
var duration_timer := Timer.new()




func _ready() -> void:
    back.pressed.connect(back_button_pressed)
    ($HBoxContainer/Submit as Button).pressed.connect(
    func()-> void:
        if current_morse_problem == null:
            (get_node("/root/Main_Node/MainGame/Main_Camera") as Camera2D).make_current()
    )
    
    ProblemGenerator.morse.connect(morse_arrive)
    ProblemGenerator.active_raid.connect(raid)
    raid_timer.timeout.connect(raid_timer_timeout)

    var sound_player: AudioStreamPlayer = $SoundPlayer
    #ALERT
    @warning_ignore("unsafe_property_access")
    sound_player.stream.mix_rate = sample_hz
    sound_player.play()
    playback = sound_player.get_stream_playback()
    #sound_player.set_volume_db(-1000.0)
    
    
    get_node(".").add_child(timer)
    timer.start(0)
    #Around 0.4 resonable
    timer.wait_time = 0.6
    timer.timeout.connect(timer_timeout)

    add_child(raid_timer)

    get_node(".").add_child(duration_timer)
    duration_timer.timeout.connect(duration_timer_timeout)

    


func raid_timer_timeout() -> void:
    timer.start()
    duration_timer.start()


func raid(duration: float) -> void:
    print("stopping morse")
    raid_timer.start(duration)
    timer.stop()
    duration_timer.stop()



    if ($HBoxContainer/LineEdit as LineEdit).text == current_morse_problem.getMessage():
        print("Success")
        emit_signal("morse_success")
        duration_timer_timeout()
    else:
        print("Fail")
        duration_timer_timeout()
        emit_signal("morse_fail")
    ($HBoxContainer/LineEdit as LineEdit).text = ""


var current_morse_problem: Morse


func duration_timer_timeout() -> void:
    morse_info.emit(morse_problem_buf.size())

    current_morse_problem = null
    morse_code_buf = []
    print("duration timed out!")
    print(morse_code_buf)
    if morse_problem_buf.size() != 0:
        current_morse_problem = morse_problem_buf.pop_front()
        print("switching")
        morse_code_buf = str_to_morse(current_morse_problem.getMessage()).duplicate()
        duration_timer.start(current_morse_problem.getDuration())
    else:
        duration_timer.stop()

    #emit stat back


var first_iteration: bool = true


func morse_arrive(morse_object: Morse) -> void:
    morse_problem_buf.append(morse_object)
    if first_iteration:
        duration_timer.start(0)
        first_iteration = false


@warning_ignore("unsafe_method_access")


func _fill_buffer(dot_dash: int) -> void:
    var increment: float = pulse_hz / sample_hz
    var local_length: int

    #Maybe use timers for the acutal pauses instead of empty frames???
    match dot_dash:
        1:
            local_length = LENGTH
        2:
            local_length = LENGTH * 3
        3:
            local_length = LENGTH
            increment = 0
        4:
            local_length = LENGTH * 3
            increment = 0
        5:
            local_length = LENGTH * 7
            increment = 0
    print(dot_dash, " ", local_length)

    while local_length > 0:
        playback.push_frame(Vector2(1, 1) * phase)
        phase = fmod(phase + increment, 1.0)
        local_length -= 1
    timer.start()


func str_to_morse(str_l: String) -> Array:
    var accumulator := []
    var char_code: String

    str_l = str_l.to_lower()

    for i in len(str_l):
        if str_l[i] != " ":
            char_code = str(char_to_morse.get(str_l[i]))
        if char_code == null:
            print("missing charachter ", str_l[i], " skipping")
            break

        for k in len(char_code):
            accumulator.append(char_code[k])
            if k == len(char_code) - 1:
                accumulator.append("4")
            else:
                accumulator.append("3")
                continue
        if str_l[i] == " ":
            accumulator.pop_back()
            accumulator.append("5")
    return accumulator


@warning_ignore("unsafe_method_access")


func timer_timeout() -> void:
    if morse_code.size() != 0:
        #ALERT This is bad, converstion has to happen in a seperate variable because of type Variant
        var temp: String = morse_code.pop_front()
        _fill_buffer(int(temp))
        ($Label2 as Label).text = "Sequence in progress!"
    else:
        if morse_code_buf.size() > 0:
            morse_code = (morse_code_buf.duplicate() as Array)
            ($Label2 as Label).text = "Starting Sequence!"


func back_button_pressed() -> void:
    ($SoundPlayer as AudioStreamPlayer).set_volume_db(-1000.0)

    var main_scene: Node2D = get_node("/root/Main_Node/MainGame")
    if main_scene != null:
        (main_scene.get_node("Main_Camera") as Camera2D).make_current()

    morse_back.emit("morse_back")
