class_name Map
var array = []
var width: int = NAN
var height: int = NAN


func _init(_width, _height, fill = null):
	width = _width
	height = _height
	
	for i in height:
		array.append([])
		for j in width:
			array[i].append(fill)
			
func getValue(x,y):
	return array[x][y]

func setValue(x, y, value):
	array[x][y] = value


	
func setValueAroundPoint(map:Map, x, y, prettyPrint=false):
	if x < 0 || x >= width:
		assert(false, "Map width is larger then it's max width")
	if y < 0 || y >= height:
		assert(false, "Map HEIGHT is larger then it's max height")
		


	var top_left = {'x': x-1, 'y': y-1}
	var top =  {'x': x-1, 'y': y}
	var top_right = {'x': x-1, 'y': y+1}
	var left = {'x': x, 'y': y-1}
	var right = {'x': x, 'y': y+1}
	var bottom_left = {'x': x+1, 'y':y-1}
	var bottom = {'x': x+1, 'y': y}
	var bottom_right = {'x': x+1, 'y': y+1}
	
	var around = [top_left, top, top_right, left, right, bottom_left, bottom, bottom_right]
	
	for i in around:
		if i.get('x') >= 0  && i.get('y') >= 0:
			if i.get('x') <= width-1 && i.get('y') <= height-1:
				map.setValue(i.get('x'),i.get('y'), 4)
				if prettyPrint:
					print("Point in X: ", i.get('x'), " ", "Point in Y: ", i.get('y'), " ", "Value is: ", map.getValue(i.get('x'),i.get('y')))
