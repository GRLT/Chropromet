extends Node

var row:int = 3
var col:int = 3
var board:Logic_Board = Logic_Board.new(row,col,20)

var gate:Dictionary = {}
var user_input:Dictionary = {}

const separation = 150
@onready var scene:Node2D = $"."
@onready var hbox: HBoxContainer = $HBoxContainer
@onready var submit: Button = $Submit
@onready var line2d_group:Node2D = $Line2DGroup
@onready var back: Button = $Back

var placeholder_val0 := preload("res://Scenes/Main_Scenes/Bool_Game/Sprite_Gate_Val0.png")
var placeholder_val1 := preload("res://Scenes/Main_Scenes/Bool_Game/Sprite_Gate_Val1.png")
var placeholder_texture := preload("res://Scenes/Main_Scenes/Bool_Game/Sprite-0001.png")

@onready var timer: Timer = $Timer
var queue: Array[Logic_Board]


func _ready() -> void:
    SignalBus.logic_game.connect(
        func(logic_board:Logic_Board) -> void:
            if queue.size() == 0:
                timer.start(1)
            queue.append(logic_board)
    )

    timer.timeout.connect(timer_timeout)

    submit.pressed.connect(
        func() -> void:
            print(check_user_input())
    )
    
    back.pressed.connect(
        func() -> void:
            SignalBus.scene_to_main.emit()
    )

func timer_timeout() -> void:
    if queue.size() == 0:
        clear_gates()
        timer.stop()

    if queue.size() > 0:
        SignalBus.fail_points.emit()
                
        timer.stop()
        board = queue.pop_front()
        row = board.row
        col = board.col
        timer.wait_time = board.duration
        timer.start()
                
        clear_gates()
        init_gate()
        init_supply()
        await  connect_gates()


func clear_gates() -> void:
    for i in hbox.get_children():
        i.queue_free()
    for i in line2d_group.get_children():
        i.queue_free()
        
 
func check_user_input() -> bool:
    for i:Logic_Gate in user_input.keys():
        var result:Logic_Gate.connection_values = i.result
        var user_value:int = user_input[i].value
        
        if result != user_value:
            return false
    if board != null:
        return false
    return true
        

func connect_gates() -> void:
    #USE THIS TO FORCE HBOX/VBOX TO UPDATE AND GET PROPER VALUES FOR TEXTURERECT
    await get_tree().process_frame
    
    var counter:int = 0
    for i:Variant in board.get_board():
        counter += 1
        for j:Logic_Gate in i:
            
            #First Column
            if counter == 1:
                #Edge case for NOT
                if j.get_selected_logic_gate_str() == "NOT":
                    var value_arr:Array = board.supply_node.keys()
                    value_arr.shuffle()
                    
                    var selected_gate:Gate_Node = value_arr[0]
                    
                    j.set_input_values([selected_gate.value])
                    j.evaluate_gate()

                    var point0:Vector2 = board.supply_node[selected_gate].global_position
                    var point1:Vector2 = gate[j].global_position
                    draw_between_points(point0, point1, -20, -50)
                    continue
                
                #First Column
                var selected_arr:Array = []
                var value_arr:Array = board.supply_node.keys()
                for k in range(2):
                    value_arr.shuffle()
                    selected_arr.append(value_arr[0])
                    value_arr.pop_front()
                
                #Set Object Value
                j.set_input_values([selected_arr[0].value, selected_arr[1].value])
                j.evaluate_gate()
                #
                ##Draw Line
                for k in range(2):
                    var point0:Vector2 = board.supply_node[selected_arr.pop_front()].global_position
                    var point1:Vector2 = gate[j].global_position
                    draw_between_points(point0, point1, -20, -50)
            
            
            
            #The rest of the gates
            else:
                #Edge case for NOT
                if j.get_selected_logic_gate_str() == "NOT":
                    var value_arr:Array = board.get_col(counter - 2)
                    value_arr.shuffle()
                    
                    var selected_gate:Logic_Gate = value_arr[0]
                    
                    j.set_input_values([selected_gate.result])
                    j.evaluate_gate()

                    var point0:Vector2 = gate[selected_gate].global_position
                    var point1:Vector2 = gate[j].global_position
                    draw_between_points(point0, point1, -100, -60)
                    continue
                
                var selected_arr:Array[Logic_Gate] = []
                var value_arr:Array = board.get_col(counter - 2)
                for k in range(2):
                    value_arr.shuffle()
                    selected_arr.append(value_arr[0])
                    value_arr.pop_front()
                
                #Set Object Value
                j.set_input_values([selected_arr[0].result, selected_arr[1].result])
                j.evaluate_gate()
                
                #Draw Line
                for k in range(2):
                    var point0:Vector2 = gate[selected_arr.pop_front()].global_position
                    var point1:Vector2 = gate[j].global_position
                    draw_between_points(point0, point1, -100, -60)
            
            
func draw_between_points(point0:Vector2, point1:Vector2, offset_x:int, offset_y:int) -> void:
    var line:Line2D = Line2D.new()
    point0 -= Vector2(offset_x, offset_y)
    line.add_point(point0)
    
    point1 -= Vector2(-30,-60)
    line.add_point(point1)
    line.width = 3.5
    line2d_group.add_child(line)

func init_supply() -> void:
    board.set_supply_val_random()
    
    var vbox:VBoxContainer = VBoxContainer.new()
    vbox.add_theme_constant_override("separation", separation)
    hbox.add_child(vbox)
    vbox.name = "input"
    hbox.move_child(vbox, 0)
    for i:Gate_Node in board.supply_node.keys():
        match i.value:
            1:
                board.supply_node[i].texture = placeholder_val1
            0:
                board.supply_node[i].texture = placeholder_val0
        #
        vbox.add_child(board.supply_node[i] as TextureRect)

func init_gate() -> void:
    hbox.add_theme_constant_override("separation", separation)
    board.set_gate_type_random()
    for i in col:
        var vbox:VBoxContainer = VBoxContainer.new()
        vbox.add_theme_constant_override("separation", 20)
        hbox.add_child(vbox)

        for j:Logic_Gate in board.get_row(i):
            var texture_rect: TextureRect = TextureRect.new()
            #FIXME REMOVE Label stuff
            var label: Label = Label.new()
            add_user_input(texture_rect)


            gate[j] = texture_rect
            texture_rect.texture = placeholder_texture
            
            #FIXME REMOVE Label stuff
            label.text = j.get_selected_logic_gate_str()
            texture_rect.add_child(label)
            vbox.add_child(texture_rect)
            
    
func add_user_input(parent: TextureRect) -> void:
    for i in col:
        for j:Logic_Gate in board.get_row(i):
            var input_box: SpinBox = SpinBox.new()
            input_box.max_value = 1
            input_box.min_value = 0
            user_input[j] = input_box
            parent.add_child(input_box)
