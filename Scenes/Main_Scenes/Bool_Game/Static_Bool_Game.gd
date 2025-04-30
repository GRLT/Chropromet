extends Node

var row:int
var col:int
var board:Logic_Board

var gate:Dictionary = {}
var user_input:Dictionary = {}

const separation = 150
@onready var scene:Node2D = $"."
@onready var hbox: HBoxContainer = $HBoxContainer
@onready var submit: Button = $Submit
@onready var back: Button = $Back
@onready var rulebook_button: Button = $RuleBook_Button
var rulebook := preload("res://Scenes/Components/book.tscn")

var placeholder_val0 := preload("res://Scenes/Main_Scenes/Bool_Game/Sprite_Gate_Val0.png")
var placeholder_val1 := preload("res://Scenes/Main_Scenes/Bool_Game/Sprite_Gate_Val1.png")
var and_gate := preload("res://Assets/Sprites/gates/and-gate.png")
var nand_gate := preload("res://Assets/Sprites/gates/nand_gate.png")
var nor_gate := preload("res://Assets/Sprites/gates/nor_gate.png")
var not_gate := preload("res://Assets/Sprites/gates/not_gate.png")
var or_gate := preload("res://Assets/Sprites/gates/or_gate.png")
var xnor_gate := preload("res://Assets/Sprites/gates/xnor_gate.png")
var xor_gate := preload("res://Assets/Sprites/gates/xor_gate.png")

@onready var timer: Timer = $Timer
@onready var check_timer: Timer = $CheckTimer


var queue: Array[Logic_Board]

var selected_board : Logic_Board
var first_loop: bool = true
func _ready() -> void:
    timer.timeout.connect(timer_timeout)
    timer.one_shot = true
    check_timer.one_shot = false
    check_timer.start(1)
    
    check_timer.timeout.connect(
        func() -> void:
        if queue.size() == 0 && timer.time_left == 0:
            clear_gates()
            SignalBus.logic_gate_complete.emit()
            
        if timer.time_left == 0 && queue.size() != 0:
            selected_board = queue.pop_front()
            timer.start(selected_board.duration)   
            board = selected_board
            await get_tree().process_frame
            
            row = selected_board.row
            col = selected_board.col
                    
            clear_gates()
            init_gate()
            init_supply()
            await connect_gates()
            
    )
    
    rulebook_button.pressed.connect(
        func() -> void:
            scene.add_child(rulebook.instantiate())
            var exception:Array[String] = ["LogicGate"]
            SignalBus.hide_book_pages_with_exception.emit(exception)
    )
    
    SignalBus.logic_game.connect(
        func(logic_board:Logic_Board) -> void:
            queue.append(logic_board)
    )


    submit.pressed.connect(
        func() -> void:
            if gate.size() == 0:
                return
            
            if !check_user_input():
                SignalBus.fail_points.emit()
                print("Fail in LogicGame")
                clear_gates()
                timer.stop()
            else:
                clear_gates()
                timer.stop()
                return
    )
    
    back.pressed.connect(
        func() -> void:
            SignalBus.scene_to_main.emit()
    )


func timer_timeout() -> void:
    SignalBus.fail_points.emit()
    


func clear_gates() -> void:
    for i in hbox.get_children():
        i.queue_free()
    for i in scene.get_children():
        if i is Line2D:
            i.queue_free()
    gate.clear()
    user_input.clear()
 
func check_user_input() -> bool:
    for i:Logic_Gate in user_input.keys():
        var result:Logic_Gate.connection_values = i.result
        var user_value:int = user_input[i].value
        print(i)
        print("result is ", result, " ", "user_value ", user_value)
        
        if result != user_value:
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
    scene.add_child(line)
    line.add_to_group("lines")

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

            var label: Label = Label.new()
            
            var input_box: SpinBox = SpinBox.new()
            input_box.max_value = 1
            input_box.min_value = 0
            user_input[j] = input_box
            input_box.position += Vector2(30,0)
            texture_rect.add_child(input_box)

            gate[j] = texture_rect
            
            var selected_logic_gate:String = j.get_selected_logic_gate_str()
            match selected_logic_gate:
                "NAND":
                    texture_rect.texture = nand_gate
                "NOR":
                    texture_rect.texture = nor_gate
                "XNOR":
                    texture_rect.texture = xnor_gate
                "XOR":
                    texture_rect.texture = xor_gate
                "AND":
                    texture_rect.texture = and_gate
                "OR":
                    texture_rect.texture = or_gate
                "NOT":
                    texture_rect.texture = not_gate


            label.text = j.get_selected_logic_gate_str()
            label.position += Vector2(30,110)
            texture_rect.add_child(label)
            vbox.add_child(texture_rect)
            
