extends CanvasLayer

func _process(_delta: float) -> void:
	$Day.text = "Day " + str(TimeManager.day)
	$Time.text = "Time: " + perunit_to_time(TimeManager.time)
	
	if(TimeManager.is_dawn_patrol()):
		$Patrol.text = 'Dawn Patrol'
	elif(TimeManager.is_hunting_patrol()):
		$Patrol.text = 'Hunting Patrol'
	elif(TimeManager.is_night_patrol()):
		$Patrol.text = 'Night Patrol'
	else:
		$Patrol.text = 'Rest'
		
func perunit_to_time(perunit: float) -> String:
	# A full day has 86,400 seconds
	var total_seconds: float = perunit * 86400.0

	# Extract components using floor division and modulo
	var hours: int = int(total_seconds / 3600)
	var minutes: int = int(fmod(total_seconds, 3600) / 60)
	#var seconds = int(fmod(total_seconds, 60))
	
	# Return as a formatted HH:MM:SS string
	#return "%02d:%02d:%02d" % [hours, minutes, seconds]

	# Return as a formatted HH:MM:SS string
	return "%02d:%02d" % [hours, minutes]
