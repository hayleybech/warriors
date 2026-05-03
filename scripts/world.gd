extends Node2D
func _ready() -> void:
	$AnimationPlayer.play("day_and_night")
	
func _process(_delta: float) -> void:
	$AnimationPlayer.seek($AnimationPlayer.get_animation("day_and_night").length * TimeManager.time)
		
