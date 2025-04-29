class_name Logic_Board

var board: Array = []
var supply_node : Dictionary = {}
var end_node: Gate_Node

var col: int = 0
var row: int = 0

func _init(col:int, row:int) -> void:
    self.col = col
    self.row = row
    for i in col:
        var row_t:Array = []
        for j in row:
            if i + j < row:
                row_t.append(Logic_Gate.new([Logic_Gate.connection_values.NONE], Logic_Gate.gate_types.NONE))
        board.append(row_t)
    
    #Set the supply, and consumer
    for i in col:
        var gate_node:Gate_Node = Gate_Node.new(Logic_Gate.connection_values.NONE)
        var texture:TextureRect = TextureRect.new()
        supply_node[gate_node] = texture
    end_node = Gate_Node.new(Logic_Gate.connection_values.NONE)

@warning_ignore("unsafe_method_access")
func set_gate_type(col:int, row:int, gate_type:Logic_Gate.gate_types) -> void:
    board[col][row].set_gate_type(gate_type)
    
@warning_ignore("untyped_declaration", "unsafe_method_access")
func set_gate_type_random() -> void:
    for i in board:
        for k:Logic_Gate in i:
            var random_gate = Logic_Gate.gate_types.values().pick_random()
            
            while random_gate == 7:
                random_gate = Logic_Gate.gate_types.values().pick_random()
                
            k.set_gate_type(random_gate as Logic_Gate.gate_types)

func set_supply_val_random() -> void:
    for i:Gate_Node in supply_node:
        var random_val:Logic_Gate.connection_values = Logic_Gate.connection_values.values().pick_random()
        while random_val == 2:
            random_val = Logic_Gate.connection_values.values().pick_random()
        i.value = random_val
    
func get_row(row: int) -> Array:
    assert(row < self.row, "You're trying to get %s row however the board's max row is %s" % [row, self.row])
    return board[row]

@warning_ignore("unsafe_method_access", "untyped_declaration")
func get_col(col: int) -> Array:
    assert(col < self.col, "You're trying to get %s col however the board's max col is %s" % [col, self.col])
    
    var temp_arr:Array = []
    for i in board[col].size():
        temp_arr.append(board[col][i])
    return temp_arr
        

func get_elem(col:int, row:int) -> Logic_Gate:
    return board[col][row]
    
func get_board() -> Array:
    return self.board
    
@warning_ignore("untyped_declaration")
func _to_string() -> String:
    var str_build: String = ""
    for i in board:
        str_build += "\n"
        for j in i:
            str_build += " | "+ str(j) + " | "
    return str_build
