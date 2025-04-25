extends Node2D
#This really should've been a class. Why did I did it like this?!

signal save_to_file(input_data: LineEdit)

@warning_ignore("unsafe_method_access", "unsafe_property_access")
func init(state: String, code: int = 0) -> void:
    var window: Window = get_node("./Window")
    var scene: Node2D = get_node(".")
    
    #Optional
    var input_line: LineEdit = get_node("./Window/VBoxContainer/LineEdit")
    var label: Label = get_node("./Window/VBoxContainer/Label")
    var button: Button = get_node("./Window/VBoxContainer/Button")
    
    
    window.connect("close_requested", 
        func() -> void:
        scene.queue_free()
        )
    
    
    #The random Texture2D obj generates "errors"
    #TODO turn in on
    #window.add_theme_icon_override("close", Texture2D.new())
    button.text = "OK"

    
    if state == "Save":
        window.name = "Save"
        label.text = "Enter the name of the save"
        button_event(button,scene, "Save", input_line)
        
    elif state == "Load":
        #window.name = "Load"
        #label.text = "Load"
        input_line.queue_free()
        label.queue_free()
        
        
    elif state == "Error":
        input_line.queue_free()
        
        window.name = "Alert"
        button_event(button,scene, "Error")
        
        match code:
            1:
                label.text = "Error: You did not added any minigame!"
            2:
                label.text = "Error: You have Missions that are not selected!"
            3:
                label.text = "Error: You forgot to fill out a field!"
            _:
                #Maybe Assert?
                push_error("Error: Alert_Window failed to find an error code: ", code)
                print("Error: Alert_Window failed to find an error code: ", code)
                window.queue_free()
            #We need this because we can't just manually call a function
            #that'll redraw it properly and set the size AFTER the text was set
            ##https://github.com/godotengine/godot/issues/20623
    elif state == "Info":
        input_line.queue_free()
        
        window.name = "Info"
        button_event(button,scene, "Info")
        
        match code:
            1:
                label.text = "Debug, you forgot to set a correct, code!"
            2:
                label.text = "You changed some values, are you sure you want to set them?"
            3:
                label.text = "Successfully Saved!"
            _:
                push_error("Error: Alert_Window failed to find an error code: ", code)
                print("Error: Alert_Window failed to find an error code: ", code)
                window.queue_free()
        
    label.set_size(label.get_minimum_size())
    overflow(window, label, 15.0)
    #For now 1152 and ~623 hard coded, due to how the game scales.
    @warning_ignore("integer_division")
    var center := (Vector2i((1152 - window.size.x)/2, window.size.y+150))
    window.set_position(Vector2(center))



#If there are any components inside the the Window that would like to overflow
#this function cloud be use to accomodate for that
static func overflow(window: Window, overflow_item: Variant, padding_x: float = 0) -> void:
    var window_size: Vector2i = window.get_size()
    
    if overflow_item is Label:
        var label: Label = overflow_item
        var label_size:Vector2i = label.get_size()
        
        #For now only overflows that occure on X
        if label_size.x > window_size.x:
            @warning_ignore("narrowing_conversion")
            window.set_size(Vector2i(label_size.x + padding_x, window_size.y))  

func button_event(button: Button, scene: Node2D,state:String, input_line:LineEdit = null) -> void:
    button.connect("pressed", 
    func() -> void:
        if state == "Error":
            scene.queue_free()
        elif state == "Info":
            scene.queue_free()
        elif state == "Save":
            if input_line.text == "":
                return
            
            if input_line:
                save_to_file.emit(input_line)
    )
