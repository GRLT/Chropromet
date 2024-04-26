extends Node2D

@onready var display = $Chiper_Display
@onready var fail = $Timeout_Timer
@onready var charachter_timeout = $Charachter_Timer
@onready var scence_back = $Back

@onready var submit_button = get_node("Keyboard/Submit")
@onready var player_input_screen = get_node("Keyboard/Player_Input_Screen")
@onready var keyboard = get_node("Keyboard")

@onready var main_game = get_node("..")

var problem_queue: Array[Caesar_Shift_Object] = []

signal stat
signal radio_info
signal chiper_back

func _ready():
	ProblemGenerator.connect("chiper", arrive_chiper)
	ProblemGenerator.connect("active_raid", raid)
	scence_back.pressed.connect(scene_back_pressed)

func scene_back_pressed():
	var main_scene = get_node("/root/Main_Node/MainGame")
	if main_scene != null:
		main_scene.get_node("Main_Camera").make_current()
		
	if emit_signal("chiper_back") == ERR_UNAVAILABLE:
		print("Failed to chiper_back signal")

func arrive_chiper(problems):
	problem_queue.append(problems)

	charachter_timeout.start()
	if !charachter_timeout.is_connected("timeout", message_print):
		charachter_timeout.timeout.connect(message_print)
	if !submit_button.is_connected("pressed", check_chiper):
		submit_button.pressed.connect(check_chiper)
	
var active := false
func send_view_info():
	if emit_signal("radio_info", problem_queue.size(), active) == ERR_UNAVAILABLE:
		print("Unable to send, radio_info signal")
	
		
var current_queue = 0
var char_counter = 0
func message_print():
	send_view_info()
	active = true
	
	if problem_queue.size() != 0:
		current_queue = problem_queue[0]
		if char_counter < current_queue.getEncrypted().length(): 
			#Szedd ki a flavour textet
			display.text ="[pulse freq=1.0 color=#00FF00 ease=-1.0]"+str(current_queue.getEncrypted()[char_counter])+"[/pulse]"
			char_counter += 1
		elif fail.time_left == 0:
			char_counter = 0
			#FIXME
			#Fail should only start after the problem was looped at least once.
			fail.start()
			if !fail.is_connected("timeout", check_chiper):
				fail.connect("timeout",check_chiper)
		else:
			char_counter = 0
	


func check_chiper():
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
				arrive_chiper(problem_queue)
				#Send back a signal with fail
				if emit_signal("stat") == ERR_UNAVAILABLE:
					print("stat signal failed with ERR_UNAVAILABLE")
	else:
		player_input_screen.text = "FAIL"
	
	
func timers_stop():
		fail.stop()
		charachter_timeout.stop()
		
## True = pause    ||   False = unpause
func timer_pause_or_resume(toggle: bool):
	print("pause")
	fail.set_paused(toggle)
	charachter_timeout.set_paused(toggle)

#Stop the timer while a raid is ongoing.
func raid(duration):
	timer_pause_or_resume(true)
	
	var countdown := Timer.new()
	add_child(countdown)
	countdown.one_shot = true
	countdown.start(duration)
	countdown.timeout.connect(countdown_end)
	

func countdown_end():
	timer_pause_or_resume(false)

#TODO
#Indicate when switching between charachters, It's really hard
#to see the difference between (ebiil tloia) when the two i / i next to eachother
#blink anmiation?
#"corrupted" animation?
# Charachter fadeing time and logic
