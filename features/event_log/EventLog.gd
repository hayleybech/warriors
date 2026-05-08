extends ScrollContainer

class_name EventLog

func _ready() -> void:
	EventManager.log_event.connect(add_item)

func add_item(type: EventManager.EventType, content: String) -> void:
	var item: Node = $VBoxContainer/LogItem.create_instance()
	item.day = TimeManager.day
	item.time = TimeManager.get_time_display()
	item.type = type
	item.content = content
	#$VBoxContainer.add_child(item)
	$VBoxContainer.move_child(item, 0)
	
	print('Day %d, %s [%s] %s' % [item.day, item.time, EventManager.EventType.find_key(item.type), item.content])
	
	
