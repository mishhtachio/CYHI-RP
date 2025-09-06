extends Node2D

const in_edit_mode: bool = false
var current_level_name = "GAME_SONG"

var level_info = {
	"GAME_SONG" = {
		# Each list = lane (Q, W, E, R)
		# Each entry = { "time": beat_time, "frame": insect_frame_index }
		"fk_times": [
			[ {"time": 1.0, "frame": 4}, {"time": 1.5, "frame": 5}, {"time": 2.0, "frame": 6} ], # Q
			[ {"time": 2.5, "frame": 5} ],                                                        # W
			[ {"time": 3.0, "frame": 7} ],                                                        # E
			[ {"time": 4.0, "frame": 4} ]                                                         # R
		],
		"music": load("res://music/game song.wav")
	}
}


func _ready():
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()

	if in_edit_mode:
		pass
	else:
		var fk_times_arr = level_info.get(current_level_name).get("fk_times")

		var counter: int = 0
		for key in fk_times_arr:
			var button_name: String = ""
			match counter:
				0: button_name = "button_Q"
				1: button_name = "button_W"
				2: button_name = "button_E"
				3: button_name = "button_R"

			for entry in key:
				var delay = entry["time"]
				var frame = entry["frame"]
				SpawnFallingKey(button_name, delay, frame)

			counter += 1


func SpawnFallingKey(button_name: String, delay: float, frame: int):
	await get_tree().create_timer(delay).timeout
	print("Spawning insect for ", button_name, " at ", delay, "s with frame ", frame)
	Signals.CreateFallingKey.emit(button_name, frame)
