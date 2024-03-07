extends Node

#5 - Base
#1 - Default Tile
#2 - Forest Tile
#3 - Enemy Tile
#4 - Dead Tile
#5 - Water Tile



func _ready():
	var mp = Map.new(10,10,1)
	
	var starting_position_x: int = randi() % (mp.width - 1)
	var starting_position_y: int = randi() % (mp.height - 1)
	if(starting_position_x < 0 || starting_position_y < 0):
		assert(false, "Random Value in Map less then 0")
	
	
	mp.setValue(starting_position_x,starting_position_y, 5)
	
	mp.setValueAroundPoint(mp,starting_position_x,starting_position_y,true)
	
	#for i in mp.array:
		#print(i)
	
