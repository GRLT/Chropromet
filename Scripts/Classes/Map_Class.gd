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
	range_check(x,y)
	return array[x][y]


func setValue(x, y, value):
	range_check(x,y)

	#assert(!(getValue(x,y) != 0), "The current coordinate is " + str(array[x][y]) + "already populated")
	
	array[x][y] = value

func range_check(x,y):
	assert(x >= 0 && x <= width-1, "X is out of range on Map")
	assert(y >= 0 && y <= height-1, "Y is out of range in Map")
	
func find_points(value):
	var point_array = []
	for i in array.size():
		for j in array.size():
			if array[i][j] == value:
				point_array.append([i,j])
	return point_array
	
	
func get_all_friendly_units():
	pass
			
	
func setValueAroundPoint(map:Map, x, y, value):
	range_check(x,y)
		
	var top_left = {'x': x-1, 'y': y-1}
	var top =  {'x': x-1, 'y': y}
	var top_right = {'x': x-1, 'y': y+1}
	var left = {'x': x, 'y': y-1}
	var right = {'x': x, 'y': y+1}
	var bottom_left = {'x': x+1, 'y':y-1}
	var bottom = {'x': x+1, 'y': y}
	var bottom_right = {'x': x+1, 'y': y+1}
	
	var around = [top_left, top, top_right, left, right, bottom_left, bottom, bottom_right]
	
	#Also checks if it's withing the array's range
	for i in around:
		if i.get('x') >= 0  && i.get('y') >= 0:
			if i.get('x') <= width-1 && i.get('y') <= height-1:
				map.setValue(i.get('x'),i.get('y'), value)
