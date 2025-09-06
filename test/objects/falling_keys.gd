extends Sprite2D

@export var fall_speed: float = 1.5
@export var init_y_pos: float = -360 

var has_passed: bool = false 
var pass_threshold = 300.0

func _process(_delta):
	global_position.y += fall_speed

	
	if global_position.y > pass_threshold and not $Timer.is_stopped():
		$Timer.stop()
		has_passed = true


func Setup(target_x: float, target_frame: int):
	frame = target_frame
	
	
	global_position = Vector2(target_x, init_y_pos)
	
	set_process(true)

func _on_delete_timeout():
	queue_free()
