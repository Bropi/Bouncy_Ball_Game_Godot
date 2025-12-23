extends Camera2D

var shake_amount = 0.4  # max pixels to shake
var shake_duration = 0.5  # seconds
var original_position = Vector2.ZERO

func _ready():
	original_position = position

func shake():
	var timer = 0.0
	while timer < shake_duration:
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		position = original_position + offset
		timer += get_process_delta_time()
		await get_tree().process_frame
	position = original_position
