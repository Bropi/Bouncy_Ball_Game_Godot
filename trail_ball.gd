extends Line2D

@export var is_ball_one := false
@export var colour_ball_one := Color('#D8D8F6')
@export var colour_ball_two := Color('#B18FCF')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_ball_one:
		default_color = colour_ball_one
	else:
		default_color = colour_ball_two
