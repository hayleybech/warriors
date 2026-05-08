extends CanvasGroup

func _process(_delta: float) -> void:
	$Day.text = "Day " + str(TimeManager.day)
	$Time.text = "Time: " + TimeManager.get_time_display()
	
	if(TimeManager.is_dawn_patrol()):
		$Patrol.text = 'Dawn Patrol'
	elif(TimeManager.is_hunting_patrol()):
		$Patrol.text = 'Hunting Patrol'
	elif(TimeManager.is_night_patrol()):
		$Patrol.text = 'Night Patrol'
	else:
		$Patrol.text = 'Rest'
	
