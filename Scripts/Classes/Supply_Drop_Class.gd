class_name Supply_Drop

var x: int
var y: int
var type: String


func _init(_x: int, _y: int, _type: String) -> void:
	self.x = _x
	self.y = _y
	self.type = _type


func getType() -> String:
	return type


func getX() -> int:
	return x


func getY() -> int:
	return y
