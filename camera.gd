extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

@export var pan_speed: int = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector('cam_move_left', 'cam_move_right', 'cam_move_up', 'cam_move_down')
	position += direction * pan_speed
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in") or event.is_action_pressed("zoom_out"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		var zoom_dir: int = 1 if event.is_action_pressed("zoom_in") else -1
		zoom += Vector2(zoom_speed * zoom_dir, zoom_speed * zoom_dir)
		zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		
		position += mouse_pos - get_global_mouse_position()
