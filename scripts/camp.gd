extends Node2D

@export var territory_radius: float = 200.00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _draw() -> void:
	const center = Vector2(0, 0) # Position relative to the node
	const start_angle = 0
	const end_angle = TAU # TAU is 2 * PI (full circle)
	const point_count = 64 # Increase for a smoother circle
	const color = Color.RED
	const width = 0.5 # Outline thickness
	const antialiased = true

	draw_arc(center, territory_radius, start_angle, end_angle, point_count, color, width, antialiased)
