extends Node2D

@onready var display = $Chiper_Display
@onready var fail = $Timeout_Timer
@onready var charachter_timeout = $Charachter_Timer

@onready var submit_button = get_node("Control/Submit")
@onready var player_input_screen = get_node("Control/Player_Input_Screen")


var problem_queue: Array[Caesar_Shift_Object] = []

signal stat


func _ready():

	
	ProblemGenerator.connect("chiper", arrive_chiper)



func arrive_chiper(problems):
	problem_queue.append(problems)

	charachter_timeout.start()
	if !charachter_timeout.is_connected("timeout", message_print):
		charachter_timeout.timeout.connect(message_print)
	if !submit_button.is_connected("pressed", check_chiper):
		submit_button.pressed.connect(check_chiper)
	
		
var current_queue = 0
var char_counter = 0
func message_print():
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
				arrive_chiper(problem_queue)
				#Send back a signal with fail
				if emit_signal("stat") == ERR_UNAVAILABLE:
					print("stat signal failed with ERR_UNAVAILABLE")
	else:
		player_input_screen.text = "FAIL"
	
	
func timers_stop():
		fail.stop()
		charachter_timeout.stop()

#TODO
#Indicate when switching between charachters, It's really hard
#to see the difference between (ebiil tloia) when the two i / i next to eachother
#blink anmiation?
#"corrupted" animation?
# Charachter fadeing time and logic
