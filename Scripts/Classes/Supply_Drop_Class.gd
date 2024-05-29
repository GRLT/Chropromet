class_name Supply_Drop

var x
var y
var type

func _init(x, y, type):
	self.x = x
	self.y = y
	self.type = type

func getType():
	return type
	
func getX():
	return x
	
func getY():
	return y
