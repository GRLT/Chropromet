extends Node

#Each day(maps) should have different instructions with different time
#between instructions. This should be the game.
#

#@onready var radio_view = get_node("MainGame/ChiperRadioView")

const TIME_BETWEEN_PROBLEMS = 2

signal chiper(problems)


var problem_timer := Timer.new()

var problems = []


func _ready():
	add_child(problem_timer)
	problem_timer.one_shot = false
	problem_timer.start(TIME_BETWEEN_PROBLEMS)
	problem_timer.timeout.connect(on_problem_timer_timeout)

	#Connections from Views
	#radio_view.stat.connect(radio_callback)
	
	#This probably needs some kinds of threading, because I want to
	#be able to generate multiple problems that cloud queue up.
	chiper_message("az")
	chiper_message("af")
	#chiper_message("av")

func radio_callback():
	print("Arrived from Radio_View")

func chiper_message(message: String):
	#var chiper_random = randi_range(-24, 24)
	var chiper_obj = Caesar_Shift_Object.new(message, 20)
	problems.push_back(chiper_obj)

	

func on_problem_timer_timeout():
	connect("stats", radio_callback)
	if problems.size() > 0:
		print("Sending Signal chiper")
		emit_signal("chiper", problems[0])
		problems.pop_front()
	
