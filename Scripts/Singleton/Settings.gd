extends Node

var config:ConfigFile = ConfigFile.new()
var file_name: String = "user://settings.cfg"
var section_name: String = "Settings"

var vsync:int
var window_mode:int
var max_fps:int
var volume:float

var key_vsync:String = "vsync"
var key_window_mode: String = "window_mode"
var key_max_fps: String = "max_fps"
var key_volume: String = "volume"

func _ready() -> void:
    load_settings()
    
    
func load_settings() -> void:
    var dir: FileAccess = FileAccess.open(file_name, FileAccess.READ)
    if dir == null:
        print(error_string(FileAccess.get_open_error()))
        
        config.set_value(section_name, key_vsync, DisplayServer.window_get_vsync_mode())
        config.set_value(section_name, key_window_mode, DisplayServer.window_get_mode())
        config.set_value(section_name, key_max_fps, Engine.max_fps)
        config.set_value(section_name, key_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
        config.save(file_name)
        
    else:
        var err:Error = config.load(file_name)
        if err != OK:
            print(error_string(err))
            return

        for i in config.get_sections():
            vsync = config.get_value(section_name, key_vsync)
            if vsync >= 0 && vsync <= 1:
                    DisplayServer.window_set_vsync_mode(vsync)
                    
            window_mode = config.get_value(section_name, key_window_mode)
            if window_mode >= 1 && window_mode <= 4:
                DisplayServer.window_set_mode(window_mode)
                
            max_fps = config.get_value(section_name, key_max_fps)
            if max_fps >= 10 && max_fps <= 144:
                Engine.set_max_fps(max_fps)
                
            volume = config.get_value(section_name, key_volume)
            if volume <= 10.0 && volume >= -10.0:
                AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

func save_settings(values: Array) -> void:
    config.set_value(section_name, key_vsync, values[0])
    config.set_value(section_name, key_window_mode, values[1])
    config.set_value(section_name, key_max_fps, values[2])
    config.set_value(section_name, key_volume,  values[3])
    
    config.save(file_name)
    

        
        
        
