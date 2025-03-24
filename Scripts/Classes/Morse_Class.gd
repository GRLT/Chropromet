class_name Morse

var duration: float = 0
var message: String = ""


func _init(_message: String, _duration: int) -> void:
    self.message = _message
    self.duration = _duration


func getMessage() -> String:
    return message


func getDuration() -> float:
    return duration
