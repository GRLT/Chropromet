extends Node

signal map_back


@onready var back_button: Button = $Back
@onready var map_container: GridContainer = $GridContainer

const MAP_WIDTH = 10
const MAP_HEIGHT = 10


#USE A TIMER
#Good solution if you want to just see the tiles
#however awful for performance and for debugger
#func _process(_delta: float) -> void:
#   refresh_tiles()
#   pass


var mp: Map = Map.new(MAP_WIDTH, MAP_HEIGHT, 0)


func callbcktestlol(x: int, y: int) -> void:
    mp.setValue(x, y, 9)


func _ready() -> void:
    map_container.columns = MAP_WIDTH

    back_button.pressed.connect(
        func() -> void:
            var main_scene: Node = get_node("/root/Main_Node/MainGame")
            if main_scene != null:
                (main_scene.get_node("Main_Camera") as Camera2D).make_current()
            map_back.emit("map_back")
    )


    var starting_position_x: int = randi() % (mp.width - 1)
    var starting_position_y: int = randi() % (mp.height - 1)
    if starting_position_x < 0 || starting_position_y < 0:
        assert(false, "Random Value in Map less then 0")

    #refresh_tiles()
    mp.setValue(1, 1, 5)
    var friendlies: Array = mp.find_points(5)
    mp.setValueAroundPoint(mp, friendlies[0][0] as int, friendlies[0][1] as int, 4)


#5 Base
#9 Success
#8 Supply [medicine]
#6 Supply [shell]
#7 Supply [weapon]
#4 Allies
#0 Default
#Costly
func supply_drop(supply_drop_local: Supply_Drop) -> void:
    var supply_type: int = 0
    match supply_drop_local.getType():
        "medicine":
            supply_type = 8
        "weapon":
            supply_type = 7
        "shell":
            supply_type = 6

    if supply_type == 0:
        print("Supply type is zero returning")
        return

    mp.setValue(supply_drop_local.getX(), supply_drop_local.getY(), supply_type)
    supply_type = 0


#func refresh_tiles() -> void:
    #for i in map_container.get_children():
        #map_container.remove_child(i)
        #i.queue_free()
    #for i: Variant in mp.array:
        #for j: Variant in i:
            #match j:
                #0:
                    #create_texture_rect_for_map(default_texture, "default")
                #5:
                    #create_texture_rect_for_map(base_texture, "base")
                #4:
                    #create_texture_rect_for_map(friendly_texture, "friendly")
                #6:
                    #create_texture_rect_for_map(supply_texture_shell, "supply_shell")
                #7:
                    #create_texture_rect_for_map(supply_texture_weapon, "supply_weapon")
                #8:
                    #create_texture_rect_for_map(supply_texture_medicine, "supply_medicinie")
                #9:
                    #create_texture_rect_for_map(checkmark_texture, "check_mark")


#func create_texture_rect_for_map(texture: CompressedTexture2D, local_name: String) -> void:
    #var new_texture: TextureRect = TextureRect.new()
    #new_texture.name = local_name
    #new_texture.texture = texture
    #map_container.add_child(new_texture)
