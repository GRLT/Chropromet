class_name Caesar_Shift_Object

var message: String = ""
var encrypted: String = ""
var shift: int = 0
	
func _init(_message, _shift) -> void:
	self.message = _message
	self.shift = _shift
	
	
	
func getMessage() -> String:
	return self.message
	
func getShift() -> int:
	return self.shift

func getEncrypted() -> String:
	return self.encrypted
