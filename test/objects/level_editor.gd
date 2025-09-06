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

	if not in_edit_mode:
		var bpm = 120
		var beat_interval = 60.0 / bpm # 0.5 seconds
		var song_length = $MusicPlayer.stream.get_length() # 16 s
		var lanes = ["button_Q", "button_W", "button_E", "button_R"]
		
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		var total_beats = int(song_length / beat_interval)
		for i in range(total_beats):
			var spawn_time = i * beat_interval
			var lane = lanes[rng.randi_range(0, lanes.size() - 1)]
			var frame = rng.randi_range(4, 7)
			SpawnFallingKey(lane, spawn_time, frame)



func SpawnFallingKey(button_name: String, delay: float, frame: int):
	await get_tree().create_timer(delay).timeout
	print("Spawning insect for ", button_name, " at ", delay, "s with frame ", frame)
	Signals.CreateFallingKey.emit(button_name, frame)
