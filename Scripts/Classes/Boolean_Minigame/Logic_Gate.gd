class_name Logic_Gate

enum gate_types{
    NOT,
    AND,
    OR,
    NAND,
    NOR,
    XOR,
    XNOR
}

enum connection_values{
    LOW,
    HIGH
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

var values: Array[connection_values] = []
var selected_logic_gate: gate_types
var result: Array[connection_values] = []

func _init(input_connections: Array[connection_values] = [connection_values], logic_gates: gate_types = gate_types) -> void:
    assert(input_connections.size() >  0, "Gate connection number is 0")
    
    self.values = input_connections
    self.selected_logic_gate = logic_gates


func evaluate_gate() -> void:
    if values.size() >= 2:
        match selected_logic_gate:
            gate_types.NOT:
                assert(false, "We only allow negating 1 value")
            gate_types.AND:
                _gate(truth_table["and_table"] as Dictionary)
            gate_types.OR:
                _gate(truth_table["or_table"] as Dictionary)
            gate_types.NAND:
                _gate(truth_table["nand_table"] as Dictionary)
            gate_types.NOR:
                _gate(truth_table["nor_table"] as Dictionary)
            gate_types.XOR:
                _gate(truth_table["xor_table"] as Dictionary)
            gate_types.XNOR:
                _gate(truth_table["xnor_table"] as Dictionary)

    elif values.size() == 1:
        _negate()


func _negate() -> void:
     if values[0] == connection_values.HIGH:
        values[0] = connection_values.LOW
     else:
        values[0] = connection_values.HIGH

func _gate(truth_table: Dictionary) -> void:
    assert(!values.size() == 1, "AND gate, was supplied with less then two conditions")
    while values.size() > 1:
        var val_l := values[0]
        var val_r := values[1]
        var result: connection_values
        
        result = truth_table[val_l][val_r]
        
        for k in range(2):
            values.remove_at(0)
        values.push_front(result)

func get_values() -> String:
    for i in values:
        return "%s " % i
    return "unreachable"
