extends Sprite2D

@onready var falling_key = preload("res://objects/falling_keys.tscn")
@onready var score_text = preload("res://objects/score_text.tscn")
@export var key_name: String = ""
@export var idle_frame: int
@export var hit_frame: int
@export var hit_duration: float = 0.15

func play_hit_animation():
	frame = hit_frame
	await get_tree().create_timer(hit_duration).timeout
	frame = idle_frame


var falling_key_queue = []

var perfect_press_threshold: float = 30
var great_press_threshold: float = 50
var good_press_threshold: float = 70
var ok_press_threshold: float = 90

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if falling_key_queue.size() > 0:
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("MISS")
			st_inst.global_position = global_position + Vector2(-100, -60)
			Signals.ResetCombo.emit()
		
	
		if Input.is_action_just_pressed(key_name):
			var key_pop = falling_key_queue.pop_front()
		
		
			var distance_from_pass = abs(key_pop.pass_threshold - key_pop.global_position.y)
			
			
			var press_score_text: String = ""
			if distance_from_pass < perfect_press_threshold:
				Signals.IncrementScore.emit(perfect_press_score)
				press_score_text = "PERFECT"
				Signals.IncrementCombo.emit()
				
			elif distance_from_pass < great_press_score:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "GREAT"
				Signals.IncrementCombo.emit()

			elif distance_from_pass < good_press_score:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "GOOD"
				Signals.IncrementCombo.emit()


			elif distance_from_pass < ok_press_score:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "OK"
				Signals.IncrementCombo.emit()

			else:
				press_score_text = "MISS"
				Signals.ResetCombo.emit()

			
			
			key_pop.queue_free()
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo(press_score_text)
			st_inst.global_position = global_position + Vector2(-100, -60)
	
	
	
func _ready():
	$RandomSpawn.wait_time = randf_range(0.4, 3)
	$RandomSpawn.start()

func CreateFallingKey(button_name: String):
	var fk_inst = falling_key.instantiate()
	get_tree().get_root().call_deferred("add_child", fk_inst)
	fk_inst.Setup(position.x, frame + 4)
	
	falling_key_queue.push_back(fk_inst)
	


func _on_random_spawn_timeout() -> void:
	
	$RandomSpawn.wait_time = randf_range(0.4, 3)
	$RandomSpawn.start()
	
func _input(event):
	if event.is_action_pressed(key_name):
		play_hit_animation()
