extends HBoxContainer

class_name EventLogItem

@export var day: int
@export var time: String
@export var type: EventManager.EventType
@export var content: String

const TYPE_COLOURS = {
	EventManager.EventType.Debug: Color('#ff6900'), # Orange 500
	EventManager.EventType.Patrol: Color('#6a7282'), # Grey 500
	EventManager.EventType.Calendar: Color('#101828'), # Grey 900
	EventManager.EventType.Social: Color('#ad46ff'), # Purple 500
}

func _ready() -> void:
	await get_tree().process_frame
	#pass
	$Time.text = 'Day ' + str(day) + ', ' + time
	$Type.text = EventManager.EventType.find_key(type)
	$Contents.text = content
	
	$Time.label_settings.font_color = TYPE_COLOURS[type]
	$Type.label_settings.font_color = TYPE_COLOURS[type]
	$Contents.label_settings.font_color = TYPE_COLOURS[type]
