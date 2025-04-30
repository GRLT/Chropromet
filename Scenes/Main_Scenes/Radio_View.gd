#class_name Radio_View
#extends Node2D
#
#signal radio_back
#signal correct_supply(x: int, y: int)
#
#@onready var itemListX: ItemList = $Container/ItemListX
#@onready var itemListY: ItemList = $Container2/ItemListY
#@onready var itemListType: ItemList = $Container3/ItemListType
#
#var supply_buffer: Array[Supply_Drop] = []
#
#
#func _ready() -> void:
    #($Container/ButtonX as Button).pressed.connect(
        #func() -> void:
        #if itemListX.visible:
            #itemListX.visible = false
        #else:
            #itemListX.visible = true
    #) 
    #
    #($Container2/ButtonY as Button).pressed.connect( 
        #func() -> void:
        #if itemListY.visible:
            #itemListY.visible = false
        #else:
            #itemListY.visible = true
    #)
    #
    #($Container3/ButtonType as Button).pressed.connect(
        #func() -> void:
        #if itemListType.visible:
            #itemListType.visible = false
        #else:
            #itemListType.visible = true
    #)
    #
    #($Back as Button).pressed.connect(
        #func() -> void:
        #var main_scene: Node2D = get_node("/root/Main_Node/MainGame")
        #if main_scene != null:
            #var main_camera: Camera2D = main_scene.get_node("Main_Camera")
            #main_camera.make_current()
        #radio_back.emit()
    #)
    #
    #($Supply_Submit as Button).pressed.connect(submit_button_pressed)
#
    #ProblemGenerator.supply_drop_signal.connect(
        #func(supply_object: Supply_Drop) -> void:
        #supply_buffer.append(supply_object)
    #)
#
    #itemListX.visible = false
    #itemListY.visible = false
    #itemListType.visible = false
#
#func submit_button_pressed() -> void:
    #if itemListX.get_selected_items().size() == 0:
        #print("ItemListX isn't selected")
        #itemListX.add_theme_color_override("font_color", Color.RED)
        #return
    #itemListX.add_theme_color_override("font_color", Color.WHITE)
#
    #if itemListY.get_selected_items().size() == 0:
        #print("ItemListY isn't selected")
        #itemListY.add_theme_color_override("font_color", Color.RED)
        #return
    #itemListY.add_theme_color_override("font_color", Color.WHITE)
#
    #if itemListType.get_selected_items().size() == 0:
        #print("ItemListType isn't selected")
        #itemListType.add_theme_color_override("font_color", Color.RED)
        #return
    #itemListType.add_theme_color_override("font_color", Color.WHITE)
#
    #var y: int = int(itemListY.get_item_text(itemListY.get_selected_items()[0])) - 1
    #var x: int = int(itemListX.get_item_text(itemListX.get_selected_items()[0])) - 1
    #var type: String = itemListType.get_item_text(itemListType.get_selected_items()[0]).to_lower()
    #print(x, " ", y)
#
    #for i: Supply_Drop in supply_buffer:
        #if x == i.getX() && y == i.getY() && type == i.getType():
            #correct_supply.emit(i.getX(), i.getY())
            #return
    #print("fail")
