extends Node2D


const in_edit_mode: bool = false
var current_level_name = "SONG 1"

var level_info = {
	"SONG 1" = {
		"fk_times": "[[1], [2], [3], [4]]"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if in_edit_mode:
		pass
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		print(fk_times_arr[0])
		
