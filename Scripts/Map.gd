extends Node

signal map_back

var base_texture := preload("res://Assets/Sprites/base.png")
var default_texture := preload("res://Assets/Sprites/rock.png")
var friendly_texture := preload("res://Assets/Sprites/friendly_unit.png")
var supply_texture_medicine := preload("res://Assets/Sprites/supply_medicine.png")
var supply_texture_weapon := preload("res://Assets/Sprites/supply_weapon.png")
var supply_texture_shell := preload("res://Assets/Sprites/supply_shell.png")
var checkmark_texture := preload("res://Assets/Sprites/Checkmark.png")

@onready var back_button = $Back
@onready var map_container = $GridContainer
@onready var radio_view = get_node("/root/Main_Node/RadioView")

const MAP_WIDTH = 10
const MAP_HEIGHT = 10

#USE A TIMER
func _process(delta):
	refresh_tiles()
	pass

var mp := Map.new(MAP_WIDTH,MAP_HEIGHT,0)
func _ready():
	print(radio_view)
	map_container.columns = MAP_WIDTH
	
	back_button.pressed.connect(scene_back_pressed)
	ProblemGenerator.supply_drop_signal.connect(supply_drop)
	radio_view.correct_supply.connect(success_supply)
	
	var starting_position_x: int = randi() % (mp.width - 1)
	var starting_position_y: int = randi() % (mp.height - 1)
	if(starting_position_x < 0 || starting_position_y < 0):
		assert(false, "Random Value in Map less then 0")
	

	refresh_tiles()
	mp.setValue(1,1,5)
	var friendlies = mp.find_points(5)
	mp.setValueAroundPoint(mp, friendlies[0][0], friendlies[0][1], 4)
	

func success_supply(x,y):
	mp.setValue(x,y,9)

#5 Base
#9 Success
#8 Supply [medicine]
#6 Supply [shell]
#7 Supply [weapon]
#4 Allies
#0 Default
#Costly
func supply_drop(supply_drop:Supply_Drop):
	var supply_type = 0
	match supply_drop.getType():
		"medicine":
			supply_type = 8
		"weapon":
			supply_type = 7
		"shell":
			supply_type = 6
			
	if supply_type == 0:
		print("Supply type is zero returning")
		return
	
	mp.setValue(supply_drop.getX(),supply_drop.getY(),supply_type)
	supply_type = 0

func refresh_tiles():
	for i in map_container.get_children():
		map_container.remove_child(i)
		i.queue_free()
	for i in mp.array:
		for j in i:
			match j:
				0:
					create_texture_rect_for_map(default_texture, "default")
				5:
					create_texture_rect_for_map(base_texture, "base")
				4:
					create_texture_rect_for_map(friendly_texture, "friendly")
				6:
					create_texture_rect_for_map(supply_texture_shell, "supply_shell")
				7:
					create_texture_rect_for_map(supply_texture_weapon, "supply_weapon")
				8: 
					create_texture_rect_for_map(supply_texture_medicine, "supply_medicinie")
				9: 
					create_texture_rect_for_map(checkmark_texture, "check_mark")
				
func create_texture_rect_for_map(texture:CompressedTexture2D, name: String):
	var new_texture = TextureRect.new()
	new_texture.name = name
	new_texture.texture = texture
	map_container.add_child(new_texture)
	
func scene_back_pressed():
	var main_scene = get_node("/root/Main_Node/MainGame")
	if main_scene != null:
		main_scene.get_node("Main_Camera").make_current()
		
	if emit_signal("map_back") == ERR_UNAVAILABLE:
		print("Failed to map_back signal")
	
