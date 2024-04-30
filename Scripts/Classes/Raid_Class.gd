class_name Raid_Object

var raid_start
var duration
func _init(_raid_start, _duration):
	self.raid_start = _raid_start
	self.duration = _duration

func getDuration():
	return duration
	
func getRaidStart():
	return raid_start
