extends Node

#Each day(maps) should have different instructions with different time
#between instructions. This should be the game.
#

const TIME_BETWEEN_PROBLEMS = 4
const WARNING_RAID_TIMER = 3


signal chiper(problems)
signal keyboard_layout(layout)
signal active_raid(duration)
signal warning_raid(toggle)

var problem_timer := Timer.new()
var signal_setup := Timer.new()
var raid_timer := Timer.new()
var warning_raid_timer := Timer.new()
var problems = []
var raid_queue
var layout = ["qwerty", "dvorak", "azerty"]

func _ready():
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
	raid_prep(1, 2)
	chiper_message("qxfv")
	#Implement for other gamemodes
	chiper_message("af")
	chiper_message("message")
	raid_prep(2, 5)
	chiper_message("message")
	#chiper_message("av")


func raid_send(raid_start, duration):
	#print("Starting warning timer")
	if emit_signal("warning_raid", true) == ERR_UNAVAILABLE:
		push_warning("Failed to send warning_raid signal!")
	warning_raid_timer.one_shot = true
	warning_raid_timer.start(WARNING_RAID_TIMER)
	warning_raid_timer.timeout.connect(warning_timer_timeout.bind(raid_start, duration))
	
	
	
	

func warning_timer_timeout(raid_start, duration):
	if emit_signal("warning_raid", false) == ERR_UNAVAILABLE:
		push_warning("Failed to send warning_raid signal!")
	#print("3 second passed")
	raid_timer.one_shot = true
	raid_timer.start(raid_start)
	raid_timer.timeout.connect(raid_timer_timeout.bind(duration))

func raid_prep(raid_start, duration):
	var raid_obj := Raid_Object.new(raid_start, duration)
	problems.push_back(raid_obj)
	
func raid_timer_timeout(duration):
	if emit_signal("active_raid", duration) == ERR_UNAVAILABLE:
		push_warning("Failed to send active_raid signal!")


func chiper_message(message: String):
	#var chiper_random = randi_range(-24, 24)
	var chiper_obj := Caesar_Shift_Object.new(message, 20)
	problems.push_back(chiper_obj)

	
func setup():
	if emit_signal("keyboard_layout", layout.pick_random()) == ERR_UNAVAILABLE:
		push_warning("Failed to send keyboard_layout signal!")
	
func on_problem_timer_timeout():
	if problems.size() > 0:
		var current = problems[0]
		if current is Caesar_Shift_Object:
			#print("Sending Signal chiper")
			emit_signal("chiper", current)
			problems.pop_front()
		if current is Raid_Object:
			raid_send(current.getRaidStart(), current.getDuration())
			problems.pop_front()

	


	

