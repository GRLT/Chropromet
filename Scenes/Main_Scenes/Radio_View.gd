extends Node2D

signal radio_back
signal correct_supply(x,y)

@onready var itemListX = $Container/ItemListX
@onready var itemListY = $Container2/ItemListY
@onready var itemListType = $Container3/ItemListType

var supply_buffer = []

func _ready():
	$Container/ButtonX.pressed.connect(buttonX_pressed)
	$Container2/ButtonY.pressed.connect(buttonY_pressed)
	$Container3/ButtonType.pressed.connect(buttonType_pressed)
	$Back.pressed.connect(back_button_pressed)
	$Supply_Submit.pressed.connect(submit_button_pressed)

	ProblemGenerator.supply_drop_signal.connect(supply_arrive)

	itemListX.visible = false
	itemListY.visible = false
	itemListType.visible = false


func supply_arrive(supply_object):
	supply_buffer.append(supply_object)

func submit_button_pressed():
	
	if itemListX.get_selected_items().size() == 0:
		print("ItemListX isn't selected")
		itemListX.add_theme_color_override("font_color", Color.RED)
		return
	itemListX.add_theme_color_override("font_color", Color.WHITE)
		
	if itemListY.get_selected_items().size() == 0:
		print("ItemListY isn't selected")
		itemListY.add_theme_color_override("font_color", Color.RED)
		return 
	itemListY.add_theme_color_override("font_color", Color.WHITE)
		
	if itemListType.get_selected_items().size() == 0:
		print("ItemListType isn't selected")
		itemListType.add_theme_color_override("font_color", Color.RED)
		return
	itemListType.add_theme_color_override("font_color", Color.WHITE)

	var y = int(itemListY.get_item_text(itemListY.get_selected_items()[0])) - 1
	var x = int(itemListX.get_item_text(itemListX.get_selected_items()[0])) - 1
	var type = itemListType.get_item_text(itemListType.get_selected_items()[0]).to_lower()
	print(x, " ",y)
	
	for i:Supply_Drop in supply_buffer:
		if x == i.getX() && y == i.getY() && type == i.getType():
			if emit_signal("correct_supply", i.getX(), i.getY()) == ERR_UNAVAILABLE:
				print("Failed to send warning_raid signal!")
			return
	print("fail")


func back_button_pressed():
		
	var main_scene = get_node("/root/Main_Node/MainGame")
	if main_scene != null:
		main_scene.get_node("Main_Camera").make_current()
	
	if emit_signal("radio_back") == ERR_UNAVAILABLE:
		print("radio_back signal failed with ERR_UNAVAILABLE")

func buttonType_pressed():
	if itemListType.visible:
		itemListType.visible = false
	else:
		itemListType.visible = true

func buttonX_pressed():
	if itemListX.visible:
		itemListX.visible = false
	else:
		itemListX.visible = true
	
func buttonY_pressed():
	if itemListY.visible:
		itemListY.visible = false
	else:
		itemListY.visible = true
