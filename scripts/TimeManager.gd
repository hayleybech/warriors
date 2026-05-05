extends Node

signal day_began

@export_group("Daytime Cycle")
@export var dawn_time: float = 0.21 # About 5 am
@export var dusk_time: float = 0.79 # About 7 pm

@export_group("Patrol Schedules")
@export var dawn_patrol_start: float = 0.21 # About 5 am
@export var dawn_patrol_end: float = 0.33 # About 8 am
@export var hunting_patrol_start: float = 0.36 # About 9 am
@export var hunting_patrol_end: float = 0.46 # About 11 am
@export var night_patrol_start: float = 0.83 # About 8 pm
@export var night_patrol_end: float = 0.96 # About 11 pm

@export_group("Clock Settings")
@export var day_length_sec: float = 40.0
@export var start_time: float = 0.00

# Start: 0.0, End 1.0
var time: float
var time_rate: float
var day: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_rate = 1.0 / day_length_sec
	time = start_time
	
	print('Day ' + str(day) + ' began.')
	#day_began.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += time_rate * delta
	if time >= 1.0:
			time = 0.0
			day += 1
			print('Day ' + str(day) + ' began.')
			day_began.emit()
			
func is_dawn_patrol() -> bool:
	return is_within_period(dawn_patrol_start, dawn_patrol_end)
func is_hunting_patrol() -> bool:
	return is_within_period(hunting_patrol_start, hunting_patrol_end)
func is_night_patrol() -> bool:
	return is_within_period(night_patrol_start, night_patrol_end)
	
func is_within_period(start: float, end: float) -> bool:
	return is_time_within_period(time, start, end)
	
static func is_time_within_period(needle: float, start: float, end: float) -> bool:
	if start <= end:
		return (start <= needle and needle <= end)
	else:
		return (needle >= start or needle <= end)
