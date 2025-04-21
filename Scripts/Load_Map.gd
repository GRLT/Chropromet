extends Control

var config: ConfigFile = ConfigFile.new()
var button_group: ButtonGroup = ButtonGroup.new()

@onready var scene:Node = get_node(".")
@onready var container:VBoxContainer = get_node("VBoxContainer")
@onready var back_button: Button = get_node("Back")



func _ready() -> void:
    container.add_theme_constant_override("separation", 20)
    back_button.pressed.connect(
        func() -> void:
        get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Title.tscn")   
    )
  
    
    var file_names:Array = get_maps_from_disk()
    create_menu(file_names)
    
    #Maybe add a warning popup here, that "Are you sure you want to load"
    button_group.pressed.connect(
        func(button: Button) -> void:
            load_data(button.text, config)
    )

@warning_ignore("unsafe_call_argument", "untyped_declaration")
func load_data(file_name:String, config: ConfigFile) -> void:
    var file_name_formatted: String = "res://Saves/%s" % file_name

    var err: Error = config.load(file_name_formatted)
    var data_from_file: Array = []
    var data: Array = []
    
    if err != OK:
        print(error_string(err))
        return
    
    
    var section: String = "Mission"
    for i in config.get_section_keys(section):
        data_from_file.append(config.get_value(section, i))
        
    for i in data_from_file:
        if i[0] == "Chiper_Game":
            var timer = i[2]
            var message = i[4]
            var shift = i[6]
            data.append(Caesar_Shift_Object.new(message as String, int(shift)))
        elif i[0] == "Morse":
            var timer = i[2]
            var message = i[4]
            data.append(Morse.new(message, int(timer)))
        elif i[0] == "Raid":
            pass

    ProblemGenerator.load_map.emit(data)
    
    get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Main_Node.tscn")

func create_menu(files: Array) -> void:
    for i in files.size():
        var button: Button = Button.new()
        
        button.text = str(files[i])
        button.button_group = button_group
        button.toggle_mode = true
        

        container.add_child(button)
    
   
func get_maps_from_disk() -> Array:
    var dir:DirAccess = DirAccess.open("res://Saves")
    var file_names: Array = []
        
    if dir:
        dir.list_dir_begin()
        var file_name := dir.get_next()
        while file_name != "":
            file_names.append(file_name)
            file_name = dir.get_next()
    else:
        print("Error, while trying to access file path")
    dir.list_dir_end()
    
    file_names.erase("")
    return file_names
