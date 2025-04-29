extends Node

@onready var scene: Node2D = $"."

var gate := preload("res://Scenes/Main_Scenes/Bool_Game/Gate.tscn")

var pos: CollisionShape2D
var draw_buff: Array[CollisionShape2D] = []
var name_buff: Array = []
var drawing: bool = false
var draw_line: bool = false

func _draw() -> void:
    if drawing:
        for i in len(draw_buff) - 1:
            if i % 2 == 0:
                scene.draw_line(draw_buff[i].global_position, draw_buff[i+1].global_position, Color.DEEP_PINK, 10.0)
    if draw_line:
        scene.draw_line(pos.global_position, get_viewport().get_mouse_position(), Color.DARK_RED, 10.0)
    
func _process(delta: float) -> void:
    if draw_line:
        scene.queue_redraw()

#@warning_ignore("unsafe_property_access")
#func _input(event: InputEvent) -> void:
    #if event is InputEventMouseButton:
        #if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && !draw_line:
            #print("asd")



func _ready() -> void:
    for i in range(2):
        var gate:Sprite2D = gate.instantiate()
        gate.position += Vector2(200*i,0)
        scene.add_child(gate)
        
        
        for k in gate.get_children():
            var area2D:Area2D = k
            area2D.input_event.connect(
                func(viewport: Node, event: InputEvent, shape_idx: int) -> void:
                if event.is_pressed():
                    pos = area2D.get_child(shape_idx)
                    name_buff.append(pos.name)
                    
                    draw_line = true
                    
                    #Check if we have a connected line already.
                    if draw_buff.has(pos):
                        print("Already connected")
                        draw_line = false
                        drawing = true
                        scene.queue_redraw()
                        return
                    
                    #if name_buff[0] == "Input0" && pos.name == "Output":
                        #print("Trying to connect an Input0 to an Output")
                        #draw_line = false
                        #drawing = true
                        #scene.queue_redraw()
                        #name_buff.clear()
                        #draw_buff.pop_back()
                        #return
                    #if name_buff[0] == "Input1" && pos.name == "Output":
                        #print("Trying to connect an Input1 to an Output")
                        #draw_line = false
                        #drawing = true
                        #scene.queue_redraw()
                        #name_buff.clear()
                        #draw_buff.pop_back()
                        #return
                        
                    
                    
                    
                    draw_buff.append(pos)
                    print(draw_buff)
                    print(name_buff)
                    
                    #Draw the lines between gates
                    if draw_buff.size() % 2 == 0:
                        draw_line = false
                        drawing = true
                        scene.queue_redraw()
                        name_buff.clear()
                        return
                    #Draw to the mouse
                    elif draw_buff.size() % 2 != 0:
                        pass
                        
        
                
                    
                    
                    
            )
            
          
