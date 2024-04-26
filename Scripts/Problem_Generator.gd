extends Node

#Each day(maps) should have different instructions with different time
#between instructions. This should be the game.
#

const TIME_BETWEEN_PROBLEMS = 2

signal chiper(problems)
signal keyboard_layout(layout)
signal active_raid(duration)

var problem_timer := Timer.new()
var signal_setup := Timer.new()
var raid_timer := Timer.new()
var problems = []
var raid_queue
var layout = ["qwerty", "dvorak", "azerty"]


func _ready():
	
	add_child(problem_timer)
	problem_timer.one_shot = false
	problem_timer.start(TIME_BETWEEN_PROBLEMS)
	problem_timer.timeout.connect(on_problem_timer_timeout)

	add_child(signal_setup)
	signal_setup.one_shot = true
	signal_setup.start(0.1)
	signal_setup.timeout.connect(setup)
	
	add_child(raid_timer)
	
	
	

	chiper_message("qxfv")
	#Implement for other gamemodes
	raid(5, 10)
	chiper_message("af")
	chiper_message("message")
	#raid(2, 5)
	chiper_message("message")
	#chiper_message("av")


func raid(raid_start, duration):

	
	raid_timer.one_shot = true
	raid_timer.start(raid_start)
	print(raid_timer.time_left)
	raid_timer.timeout.connect(raid_timer_timeout.bind(duration))

	
func raid_timer_timeout(duration):
	print(duration)
	if emit_signal("active_raid", duration) == ERR_UNAVAILABLE:
		print("Failed to send active_raid signal!")


func chiper_message(message: String):
	#var chiper_random = randi_range(-24, 24)
	var chiper_obj = Caesar_Shift_Object.new(message, 20)
	problems.push_back(chiper_obj)

	
func setup():
	if emit_signal("keyboard_layout", layout.pick_random()) == ERR_UNAVAILABLE:
		print("Failed to send keyboard_layout signal!")
	
func on_problem_timer_timeout():
	if problems.size() > 0:
		#print("Sending Signal chiper")
		emit_signal("chiper", problems[0])
		problems.pop_front()
	

