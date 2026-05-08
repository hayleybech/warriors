extends Node

@warning_ignore("unused_signal")
signal log_event(type: EventType, content: String)

enum EventType {Debug, Patrol, Social, Calendar}
