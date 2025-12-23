extends Node2D

@onready var ball_1: Ball = %Ball1
@onready var ball_2: Ball = %Ball2
@onready var trail_ball_1: Line2D = $TrailBall1
@onready var trail_ball_2: Line2D = $TrailBall2
@onready var camera_2d: Camera2D = $Camera2D

var trail_max_points := 25
var trail_offset := Vector2(4, 4)  # offset 4 pixels down/right



func _process(_delta: float) -> void:
	# Ball 1
	trail_ball_1.add_point(ball_1.global_position + trail_offset)

	if trail_ball_1.points.size() > trail_max_points:
		trail_ball_1.remove_point(0)

	# Ball 2
	trail_ball_2.add_point(ball_2.global_position + trail_offset)

	if trail_ball_2.points.size() > trail_max_points:
		trail_ball_2.remove_point(0)


func shake_camera() -> void:
	camera_2d.shake()
