extends Node2D


@onready var new_mission: Button = $New_Mission
@onready var save_into_file: Button = $Save
@onready var tree_container: VBoxContainer = $Tree_Container/VBoxContainer
@onready var scene: Node2D  = get_node(".")

var alert_win := preload("res://Scenes/Components/Alert_Window.tscn").instantiate()
    
var config:ConfigFile = ConfigFile.new()

var mini_games: Array = ["Morse", "Chiper_Game", "Raid"]    
var time_range: Array = [20, 30, 45, 60, 120]



@warning_ignore("unsafe_property_access", "unsafe_method_access")
func _ready() -> void:
    new_mission.connect("pressed", new_mission_pressed)
    save_into_file.connect("pressed", save_pressed)
    
    
    #Separatin between container elems
    tree_container.add_theme_constant_override("separation", 20)


@warning_ignore("untyped_declaration", "unsafe_method_access")
func create_child_elems(origin, elems:Array) -> void:
    for i in elems.size():
            origin.add_child(elems[i])

var data: Array = []
var counter: int = 0
@warning_ignore("unsafe_method_access", "unsafe_property_access")
#TODO replace init() with a signal, altough this works
func save_pressed() -> void:
    alert_win = preload("res://Scenes/Components/Alert_Window.tscn").instantiate()
    if tree_container.get_child_count() >= 1:
        var val_name:String
        for i in tree_container.get_children():
            counter += 1
            for k in i.get_children():
                if k is OptionButton && k.text == "Mission Not Selected":
                    alert_win.init("Error", 2)
                    scene.add_child(alert_win)
                    return
                if k is LineEdit && k.text == "":
                    alert_win.init("Error", 3)
                    scene.add_child(alert_win)
                    return
                   
                if k is Label && k.text != "Mission Type":
                    data.append(k.text)
                if k is OptionButton:
                    data.append(k.get_item_text(k.selected))
                if k is LineEdit:
                    data.append(k.text)
                if k is SpinBox:
                    data.append(k.get_line_edit().text)
            config.set_value("Mission", str(counter), data)
            data = []
        
        alert_win.init("Save", 0)
        alert_win.connect("save_to_file", alert_window)
        scene.add_child(alert_win)
    elif !scene.get_node_or_null("AlertWindow/Alert"):
        alert_win.init("Error", 1)
        scene.add_child(alert_win)
    #print(data)
    
    

func reset_mission_state(container: HBoxContainer) -> void:
    pass

@warning_ignore("unsafe_property_access", "unsafe_method_access")
func new_mission_pressed() -> void:
    var label_mission: Label = Label.new()
    var lable_time: Label = Label.new()
    var option_button_mission: OptionButton = OptionButton.new()
    var option_button_time: OptionButton = OptionButton.new()
    var container: HBoxContainer = HBoxContainer.new()
    
    #TODO
    #This function should be vacated from here, but it's
    #pretty neat here, becasue the variables in here are still in scope
    option_button_mission.item_selected.connect(
        func(index:int) -> void:
            var selected_text := option_button_mission.get_item_text(index)

            if container.get_child_count() >= 4:
                var counter: int = 0
                for i in container.get_children():
                    if counter >= 4:
                        container.remove_child(i)
                    counter += 1
                    
            if option_button_mission.get_item_text(0) == "Mission Not Selected":
                        option_button_mission.remove_item(0)
                        option_button_mission.select(index-1)
            
            
            match selected_text:
                "Morse":
                    var message_label: Label = Label.new()
                    message_label.text = "Message"
                    var message: LineEdit = LineEdit.new()
                    message.max_length = 6
                    create_child_elems(container, [message_label, message])
                    
                "Chiper_Game":
                    var message_label: Label = Label.new()
                    message_label.text = "Message"
                    var message: LineEdit = LineEdit.new()
                    message.max_length = 10
                    
                    var shift_label: Label = Label.new()
                    shift_label.text = "Shift"
                    var shift: SpinBox = SpinBox.new()  
                    shift.max_value = 24
                    shift.min_value = -24
                    
                    create_child_elems(container, [message_label, message, shift_label,shift])
                "Raid":
                    pass
                

    )
    
    label_mission.text = "Mission Type"  
    lable_time.text = "Timer"
    option_button_mission.allow_reselect = false
    
    option_button_mission.add_item("Mission Not Selected")
    for i in mini_games.size():
        var mini_games_i:String = mini_games[i]
        option_button_mission.add_item(mini_games_i)
    for i in time_range.size():
        var time_range_i:String = str(time_range[i])
        option_button_time.add_item(time_range_i)


    tree_container.add_child(container)
    create_child_elems(container, [label_mission, option_button_mission, lable_time, option_button_time])

func alert_window(input_data:LineEdit) -> void:
    var dir: DirAccess = DirAccess.open("res://")
    print("arrived from signal")
    var path:String = input_data.text
    alert_win.queue_free()
    
    path = path.to_lower()
    if path.find(".", 0) == -1:
        path += ".cfg"
    
    #ALERT TODO This needs to be change to user://
    if !dir.dir_exists("res://Saves"):
        dir.make_dir("res://Saves")
        
    path = "res://Saves/%s" % path

    var ret := config.save(path)
    
    if ret != OK:
        error_string(ret)
    else:
        print("Successfully saved %s" % path)
