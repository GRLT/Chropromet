class_name Morse

var duration = 0
var message = ""

func _init(message: String, duration: int):
	self.message = message
	self.duration = duration
	
	
func getMessage():
	return message
	
func getDuration():
	return duration
