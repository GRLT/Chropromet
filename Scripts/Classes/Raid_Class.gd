class_name Raid_Object

var raid_start: float
var duration: float
var warning_timer: float

func _init(raid_start: float, duration: float, warning_timer: float) -> void:
    self.raid_start = raid_start
    self.duration = duration
    self.warning_timer = warning_timer
