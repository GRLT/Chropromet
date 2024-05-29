#BUFFER_LEN SET TO MAX

extends Node

signal morse_back
signal morse_info(pool_size)
signal morse_status(status)

@onready var back = $Back

#Limit the length beacuse the AudioStreamGenerator buffer dies
#Either incrase the buffer size or keep it in range (~450<)
const LENGTH = 300
enum morse_type {
DOT = 1,
DASH = 2,
EMPTY = 3,
CHAR_SEP = 4,
WORD_SEP = 5
}
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
var sample_hz = 1200.0
var pulse_hz = 4000.0
var phase = 0.0
var playback: AudioStreamPlayback = null
var morse_code := []
var morse_code_buf := [] 
var morse_problem_buf := []

var timer := Timer.new()
var duration_timer := Timer.new()

func _ready():
	back.pressed.connect(back_button_pressed)
	$HBoxContainer/Submit.pressed.connect(submit_button_pressed)
	ProblemGenerator.morse.connect(morse_arrive)

	$SoundPlayer.stream.mix_rate = sample_hz
	$SoundPlayer.play()
	$SoundPlayer.set_volume_db(-1000.0)

	playback = $SoundPlayer.get_stream_playback()
	get_node(".").add_child(timer)
	timer.start(0)
	#Around 0.4 resonable
	timer.wait_time = 0.5
	timer.timeout.connect(timer_timeout)
	
	get_node(".").add_child(duration_timer)
	duration_timer.timeout.connect(duration_timer_timeout)
	
	
func submit_button_pressed():
	if $HBoxContainer/LineEdit.text == current_morse_problem.getMessage():
		print("Success")
		emit_signal("morse_success")
		duration_timer_timeout()
	else:
		print("Fail")
		duration_timer_timeout()
		emit_signal("morse_fail")
	
var current_morse_problem
func duration_timer_timeout():
	if emit_signal("morse_info", morse_problem_buf.size()) == ERR_UNAVAILABLE:
		print("Failed to send morse_info signal!")
		
	current_morse_problem = null
	morse_code_buf = []
	morse_code = []
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
var first_iteration = true
func morse_arrive(morse_object: Morse):
	morse_problem_buf.append(morse_object)
	if first_iteration: 
		duration_timer.start(0)
		first_iteration = false


func _fill_buffer(dot_dash):
	var increment = pulse_hz / sample_hz
	var local_length

	#Maybe use timers for the acutal pauses instead of empty frames???
	match dot_dash:
		1:
			local_length = LENGTH
		2:
			local_length = LENGTH*3
		3:
			local_length = LENGTH
			increment = 0
		4: 
			local_length = LENGTH*3
			increment = 0
		5:
			local_length = LENGTH*7
			increment = 0
	print(dot_dash, " ", local_length)
	
	while local_length > 0:
		#playback.push_frame(Vector2.ONE * sin(phase * TAU))
		playback.push_frame(Vector2(1,1) * phase)
		phase = fmod(phase + increment, 1.0)
		local_length -= 1
	timer.start()


#DOT = 1,
#DASH = 2,
#EMPTY = 3,
#CHAR_SEP = 4,
#WORD_SEP = 5
#DOT, EMPTY, DASH, EMPTY, DASH, EMPTY, DOT, "4", "1"
#, "3", "2", "4", "1", "3", "2", "3", "1", "4",
 #"1", "3", "1", "4", "1", "3", "1", "3", "1", "4"
func str_to_morse(str : String):
	var accumulator := []
	var char_code
	
	str = str.to_lower()
	
	for i in len(str):
		if str[i] != " ":
			char_code = char_to_morse.get(str[i])
		if char_code == null:
			print("missing charachter ", str[i], " skipping")
			break
		
		#Easier to work with it a String
		char_code = str(char_code)
		for k in len(char_code):
			accumulator.append(char_code[k])
			if k == len(char_code)-1:
				accumulator.append("4")
			else:
				accumulator.append("3")
				continue
		if str[i] == " ":
			accumulator.pop_back()
			accumulator.append("5")
	return accumulator

func timer_timeout():
	if morse_code.size() != 0:
		_fill_buffer(int(morse_code.pop_front()))
		$Label2.text = "Sequence in progress!"
	else:
		if (playback.get_frames_available() > 16000 && morse_code_buf.size() > 0):
			morse_code = morse_code_buf.duplicate()
			$Label2.text = "Starting Sequence!"

func back_button_pressed():
	$SoundPlayer.set_volume_db(-1000.0)
	
	var main_scene = get_node("/root/Main_Node/MainGame")
	if main_scene != null:
		main_scene.get_node("Main_Camera").make_current()
	
	if emit_signal("morse_back") == ERR_UNAVAILABLE:
		print("Morse_Back signal failed with ERR_UNAVAILABLE")
