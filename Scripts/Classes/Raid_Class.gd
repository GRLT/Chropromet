class_name Raid_Object

var raid_start: float
var duration: float


func _init(_raid_start: float, _duration: float) -> void:
	self.raid_start = _raid_start
	self.duration = _duration


func getDuration() -> float:
	return duration


func getRaidStart() -> float:
	return raid_start
