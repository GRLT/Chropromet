
extends Node

signal morse_back


@onready var back: Button = $Back
@onready var morse: Node2D = get_node(".")
@onready var input_box: LineEdit = $HBoxContainer/LineEdit
const wait_time_between_problems = 2
 

#LIMIT FRAMES, EXCESSIVE CPU USE!!!
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
var sample_hz: float = 5000.0
var pulse_hz: float = 200.0
var phase: float = 80

var playback: AudioStreamGeneratorPlayback = null #
var morse_code: Array = [] #1 OR 2 SINGLE INTEGER
var morse_code_buf: Array = [] #SEQUENCE OF [1,2,3,1,2]
var morse_problem_buf := [] #MORSE PROBLEM OBJ

var frame_timer := Timer.new()
var timeout_timer := Timer.new()



@onready var sound_player: AudioStreamPlayer = $SoundPlayer

var first_iteration: bool = true
func morse_arrive(morse_object: Morse) -> void:
    morse_problem_buf.append(morse_object)
    if first_iteration:
        timeout_timer.start(0.5)
        first_iteration = false

func _ready() -> void:
    get_node(".").add_child(timeout_timer)
    timeout_timer.timeout.connect(timeout_timer_timeout)   
    back.pressed.connect(
        func() -> void:
        SignalBus.scene_to_main.emit()
        )
    ($HBoxContainer/Submit as Button).pressed.connect(
    func()-> void:
            if morse_code_buf.size() > 0:
                if current_morse_problem.getMessage() == input_box.text:
                    print_rich("[color=green]Good job!")
                else:
                    print_rich("[color=red]You failed!")
                if morse_code_buf.front() == null:
                    print("Empty morse buffer!")
            next_morse_problem()
    )
    ProblemGenerator.morse.connect(morse_arrive)

    #ALERT
    @warning_ignore("unsafe_property_access")
    sound_player.stream.mix_rate = sample_hz
    sound_player.play()
    playback = sound_player.get_stream_playback()
    sound_player.set_volume_db(-20.0)
    
    
    get_node(".").add_child(frame_timer)
    frame_timer.start(0)
    #Around 0.4 resonable
    frame_timer.wait_time = 0.4
    frame_timer.timeout.connect(frame_timer_timeout)

var first: bool = false
var current_morse_problem: Morse = null
func timeout_timer_timeout() -> void:    
    if morse_problem_buf.size() != 0:
        current_morse_problem = morse_problem_buf.pop_front()
        morse_code_buf = str_to_morse(current_morse_problem.getMessage()).duplicate()
        
        if !sound_player.playing:
            sound_player.play()
            playback = sound_player.get_stream_playback()
        timeout_timer.start(current_morse_problem.getDuration())
        if first:
            frame_timer.wait_time = 2
            first = true
    else:
        next_morse_problem()
        


func next_morse_problem() -> void:
    timeout_timer.wait_time = wait_time_between_problems
    timeout_timer.start()
    sound_player.stop()
    morse_code = []
    morse_code_buf = []
    draw_standing()
    morse.queue_redraw()



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
            
    while local_length > 0:
        phase = fmod(phase + increment, 0.2)
        playback.push_frame(Vector2(3, 3) * phase * TAU)
        local_length -= 1
    frame_timer.start()


func str_to_morse(str_l: String) -> Array:
    var accumulator := []
    var char_code: Variant
    
    str_l = str_l.to_lower()

    for i in len(str_l):
        if str_l[i] != " ":
            char_code = char_to_morse.get(str_l[i])
        #IF I CAST CHAR_CODE ABOVE TO STR THE BELOW CHECK REFUSE TO WORK
        if char_code == null:
            print("missing charachter \"", str_l[i], "\" skipping")
            break
            
        char_code = str(char_code)
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



var playing_morse_code: String = ""
@warning_ignore("unsafe_method_access", "unsafe_property_access")
func frame_timer_timeout() -> void:
    frame_timer.wait_time = 0.4

    if morse_code.size() != 0:
        morse.queue_redraw()
        playing_morse_code = morse_code.pop_front()
        _fill_buffer(int(playing_morse_code))
        ($Label2 as Label).text = "Sequence in progress!"
    elif morse_code_buf.size() > 0:
            morse_code = (morse_code_buf.duplicate() as Array)
            ($Label2 as Label).text = "Starting Sequence!"




var counter:int = 0
var func_value_a:int = 0 
var func_value_b:int = 0
var x_scale:int = 100
var x_offset:int = 500
var y_offset:int = 400
@onready var line2d:Line2D = $Wave
func draw_trinagle() -> void:
 for i in range(-10,10,1):
            func_value_a = 0
            if i < 1:
                func_value_a = 1 - abs(i)
            var max_val:int = max(func_value_a, func_value_b)
            line2d.add_point(Vector2(i*x_scale+x_offset, -max_val*100+y_offset),counter)
            counter += 1

func draw_standing() -> void:
    for i in range(-10,10,1):
            line2d.add_point( Vector2(i*x_scale+x_offset, 0+y_offset),counter)
            counter += 1

func draw_climb() -> void:
    var x:int = 0
    for i in range(-10,10,1):
            if i >= 2 && i <= 10:
                x = -150
                line2d.add_point(Vector2(i*x_scale+350, x+y_offset),counter)
            else:
                x = 1
                line2d.add_point(Vector2(i*x_scale+350, 5+y_offset),counter)
            counter += 1

func _draw() -> void:
    line2d.clear_points()
    if sound_player.playing:
        match int(playing_morse_code):
            morse_type.DOT:
                draw_trinagle()
            morse_type.DASH:
                 draw_climb()
            morse_type.EMPTY:
                draw_standing()
            morse_type.CHAR_SEP:
                draw_standing()
            _:
                draw_standing()
    else:
        draw_standing()
    return
