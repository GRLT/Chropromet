class_name Logic_Gate

enum gate_types{
    NOT,
    AND,
    OR,
    NAND,
    NOR,
    XOR,
    XNOR,
    NONE
}

enum connection_values{
    LOW,
    HIGH,
    NONE
}


const truth_table:Dictionary = {
        and_table = {
        0: {0: connection_values.LOW, 1: connection_values.LOW},
        1: {0: connection_values.LOW, 1: connection_values.HIGH}
        },
        or_table = {
        0: {0: connection_values.LOW, 1: connection_values.HIGH},
        1: {0: connection_values.HIGH, 1: connection_values.HIGH}
        },
        nand_table = {
        0: {0: connection_values.HIGH, 1: connection_values.HIGH},
        1: {0: connection_values.HIGH, 1: connection_values.LOW}
        },
        nor_table = {
        0: {0: connection_values.HIGH, 1: connection_values.LOW},
        1: {0: connection_values.LOW, 1: connection_values.LOW}
        },
        xor_table = {
        0: {0: connection_values.LOW, 1: connection_values.HIGH},
        1: {0: connection_values.HIGH, 1: connection_values.LOW}
        },
        xnor_table = {
        0: {0: connection_values.HIGH, 1: connection_values.LOW},
        1: {0: connection_values.LOW, 1: connection_values.HIGH}
        }
}

var input_connections: Array[connection_values] = []
var selected_logic_gate: gate_types

var result: connection_values

func _init(input_connections: Array[connection_values] = [connection_values], logic_gates: gate_types = gate_types) -> void:
    assert(input_connections.size() >  0, "Gate connection number is 0")
    
    self.input_connections = input_connections
    self.selected_logic_gate = logic_gates


func evaluate_gate() -> void:
    if input_connections.size() == 1:
        _negate()
        return
    
    if input_connections.size() >= 2:
        match selected_logic_gate:
            gate_types.NOT:
                assert(false, "We only allow negating 1 value")
                return
            gate_types.AND:
                _gate(truth_table["and_table"] as Dictionary)
                return
            gate_types.OR:
                _gate(truth_table["or_table"] as Dictionary)
                return
            gate_types.NAND:
                _gate(truth_table["nand_table"] as Dictionary)
                return
            gate_types.NOR:
                _gate(truth_table["nor_table"] as Dictionary)
                return
            gate_types.XOR:
                _gate(truth_table["xor_table"] as Dictionary)
                return
            gate_types.XNOR:
                _gate(truth_table["xnor_table"] as Dictionary)
                return
        

func _negate() -> void:
     if input_connections[0] == connection_values.HIGH:
        result = connection_values.LOW
     else:
        result = connection_values.HIGH

func _gate(truth_table: Dictionary) -> void:
    assert(!input_connections.size() == 1, "Gate, was supplied with less then two conditions")
    var eval_arr: Array[connection_values] = input_connections.duplicate()
    while eval_arr.size() > 1:
        var val_l := eval_arr[0]
        var val_r := eval_arr[1]
        var result: connection_values
        
        result = truth_table[val_l][val_r]
        
        for k in range(2):
            eval_arr.remove_at(0)
        eval_arr.push_front(result)
        
    self.result = eval_arr.pop_front()


func _to_string() -> String:
    var str_build: String = "Connections:"
    for i in input_connections:
        str_build += " " + connection_values.keys()[i]
    
    str_build += " Gate Type: %s" % gate_types.keys()[selected_logic_gate]
    

    str_build += " Result is: %s \n" % connection_values.keys()[result]
    
    return str_build

func set_gate_type(gate_type:Logic_Gate.gate_types) -> void:
    selected_logic_gate = gate_type

func set_input_values(values:Array[Logic_Gate.connection_values]) -> void:
    input_connections = values

func get_values_str() -> String:
    for i in input_connections:
        return "%s " % i
    return "unreachable"
    
func get_selected_logic_gate() -> Logic_Gate.gate_types:
    return self.selected_logic_gate

func get_selected_logic_gate_str() -> String:
    return gate_types.keys()[self.selected_logic_gate]
