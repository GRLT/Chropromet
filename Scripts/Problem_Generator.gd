extends Node

#Each day(maps) should have different instructions with different time
#between instructions. This should be the game.
#

const TIME_BETWEEN_PROBLEMS = 2

signal chiper(problems)

var problem_timer := Timer.new()

var problems = []

func _ready():
	add_child(problem_timer)
	problem_timer.one_shot = false
	problem_timer.start(TIME_BETWEEN_PROBLEMS)
	problem_timer.timeout.connect(on_problem_timer_timeout, 4)
	
	#This probably needs some kinds of threading, because I want to
	#be able to generate multiple problems that cloud queue up.
	chiper_send_signal_on_timeout("ez")
	chiper_send_signal_on_timeout("itt van a vilag")
	chiper_send_signal_on_timeout("ua")

func chiper_send_signal_on_timeout(message: String):
	var chiper_random = randi_range(-24, 24)
	var chiper_obj = Caesar_Shift_Object.new(message, chiper_random)
	problems.push_front(chiper_obj)
	

func on_problem_timer_timeout():
	emit_signal("chiper", problems)
