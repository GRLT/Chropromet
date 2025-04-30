extends Node

@onready var scene:Node = $"."



var warning_timer:Timer = Timer.new()
var raid_duration:Timer = Timer.new()
var raid_wait: Timer = Timer.new()
var check_timer: Timer = Timer.new()

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
var area_clear_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var siren := preload("res://Assets/Sound/SFX/siren_1.mp3")
@onready var cannon_sfx := preload("res://Assets/Sound/SFX/cannon_mixed.mp3")
@onready var area_clear := preload("res://Assets/Sound/SFX/Area_Clear.mp3")

func setup_timer() -> void:
    check_timer.name = "check_timer"
    warning_timer.name = "warning_timer"
    raid_duration.name = "raid_duration"
    raid_wait.name = "raid_wait"
    
    check_timer.one_shot = false
    warning_timer.one_shot = true
    raid_duration.one_shot = true
    raid_wait.one_shot = true
    
    scene.add_child(check_timer)
    check_timer.start(1)
    scene.add_child(warning_timer)
    scene.add_child(raid_duration)
    scene.add_child(raid_wait)
    
func _process(delta: float) -> void:
    print(raid_wait.time_left)

var current_raid_object: Array[Raid_Object]
var currently_selected_raid_object: Raid_Object
func _ready() -> void:
    setup_timer()
    scene.add_child(audio_stream_player)
    scene.add_child(area_clear_player)
    audio_stream_player.finished.connect(
        func() -> void:
            audio_stream_player.play(randi() % 10)
    )
    SignalBus.raid_prep.connect(raid_prep)
    
    raid_wait.timeout.connect(
        func() -> void:
            warning_timer.start(currently_selected_raid_object.warning_timer)
            
            raid_duration.start(currently_selected_raid_object.duration)
            audio_stream_player.stream = siren
            audio_stream_player.play()
    )

    warning_timer.timeout.connect(
        func() -> void:
            audio_stream_player.stop()
            
            audio_stream_player.stream = cannon_sfx
            audio_stream_player.play()
            var active_camera:Camera2D = get_viewport().get_camera_2d()
            if active_camera.name != "RaidCamera":
                audio_stream_player.stop()
                area_clear_player.stop()
                raid_duration.stop()
                get_tree().change_scene_to_file("res://Scenes/Main_Scenes/Fail.tscn")
    )
    
    raid_duration.timeout.connect(
        func() -> void:
            audio_stream_player.stop()
            
            area_clear_player.stream = area_clear
            area_clear_player.play()
    )
    
    check_timer.timeout.connect(
        func() -> void:
            if warning_timer.time_left == 0 && raid_duration.time_left == 0 && raid_wait.time_left == 0 && current_raid_object.size() != 0:
                currently_selected_raid_object = current_raid_object.pop_front()
                raid_wait.start(currently_selected_raid_object.raid_start)
    )
    
func raid_prep(current_raid_object: Raid_Object) -> void:
    self.current_raid_object.append(current_raid_object)
    #raid_wait.start(current_raid_object.raid_start)
