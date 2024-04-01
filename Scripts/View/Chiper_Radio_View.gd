extends Node2D

@onready var display = $Chiper_Display

@onready var fail = $Timeout_Timer
@onready var charachter_timeout = $Charachter_Timer
@onready var keyboard_popup = $"QWERTZ Controller"


var char_counter = 0
var queue = []

const repeat = 3

func _ready():


	ProblemGenerator.connect("chiper", arrive_chiper)


func arrive_chiper(problems):
	queue = problems


	charachter_timeout.start()
	charachter_timeout.timeout.connect(message_print)
	for i in queue:
		print(i.getEncrypted())
		pass
		

func message_print():
	var current_queue = 0
	if queue.size() != 0:
		current_queue = queue[0]
		if char_counter < current_queue.getEncrypted().length(): 
			#Szedd ki a flavour textet
			display.text ="[pulse freq=1.0 color=#00FF00 ease=-1.0]"+str(current_queue.getEncrypted()[char_counter])+"[/pulse]"
			char_counter += 1
		elif fail.time_left == 0:
			char_counter = 0
			fail.start()
			fail.timeout.connect(fail_chiper)
		else:
			char_counter = 0
	


func fail_chiper():
	fail.stop()
	charachter_timeout.stop()
	print("Entered fail")
	if queue.size() != 0:
		queue.pop_front()
		display.text = "FAIL"
		arrive_chiper(queue)
	#Send back a signal with fail
	

#TODO
#Indicate when switching between charachters, It's really hard
#to see the difference between (ebiil tloia) when the two i / i next to eachother
#blink anmiation?
#"corrupted" animation?
# Charachter fadeing time and logic
