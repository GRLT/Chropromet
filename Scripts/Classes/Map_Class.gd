class_name Map
var array := []
var width: int = 0
var height: int = 0


func _init(_width: int, _height: int, fill_tiles: int = 0) -> void:
	width = _width
	height = _height

	for i: Variant in height:
		array.append([])
		for j in width:
			(array[i] as Array).append(fill_tiles)


func getValue(x: int, y: int) -> Array[int]:
	range_check(x, y)
	return array[x][y]


func setValue(x: int, y: int, value: int) -> void:
	range_check(x, y)

	array[x][y] = value
	#assert(!(getValue(x,y) != 0), "The current coordinate is " + str(array[x][y]) + "already populated")


func range_check(x: Variant, y: Variant) -> void:
	assert(x >= 0 && x <= width - 1, "X is out of range on Map")
	assert(y >= 0 && y <= height - 1, "Y is out of range in Map")


func find_points(value: int) -> Array:
	var point_array: Array = []
	for i in array.size():
		for j in array.size():
			if array[i][j] == value:
				point_array.append([i, j])
	return point_array


func get_all_friendly_units() -> void:
	pass


func setValueAroundPoint(map: Map, x: int, y: int, value: int) -> void:
	range_check(x, y)

	var top_left: Dictionary = {"x": x - 1, "y": y - 1}
	var top: Dictionary = {"x": x - 1, "y": y}
	var top_right: Dictionary = {"x": x - 1, "y": y + 1}
	var left: Dictionary = {"x": x, "y": y - 1}
	var right: Dictionary = {"x": x, "y": y + 1}
	var bottom_left: Dictionary = {"x": x + 1, "y": y - 1}
	var bottom: Dictionary = {"x": x + 1, "y": y}
	var bottom_right: Dictionary = {"x": x + 1, "y": y + 1}

	var around: Array = [top_left, top, top_right, left, right, bottom_left, bottom, bottom_right]

	#Also checks if it's withing the array's range
	for i: Dictionary in around:
		if i.get("x") >= 0 && i.get("y") >= 0:
			if i.get("x") <= width - 1 && i.get("y") <= height - 1:
				map.setValue((i.get("x") as int) as int, i.get("y") as int, value)
