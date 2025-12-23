extends StaticBody2D
class_name Tile

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var game: Node2D = $"../.."

@export var ball: Ball

var scale_tween = null
var mat = null

func _ready() -> void:
	mat = gpu_particles_2d.process_material 
	set_color()


func toggle(collided_ball: Ball) -> void:
	ball = collided_ball
	
	# Switch colour
	set_color()
	
	# Set collision layer to layer that the collided ball is on.
	collision_layer = ball._get_collision_layer()
	
	game.shake_camera()
	
	# Fire Particles
	#gpu_particles_2d.color set this color
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
	
	# Call tweens when collision happens
	tween_polygon_pulse_once(Vector2(1,1), Vector2(1.5,1.5), 0.3)
	


func set_color() -> void:
	# Set the colour to the opposite ball's colour
	if ball.is_ball_one:
		polygon_2d.color = ball.colour_ball_two
		mat.color = ball.colour_ball_two
	else:
		polygon_2d.color = ball.colour_ball_one
		mat.color = ball.colour_ball_one


func tween_polygon_pulse_once(min_scale: Vector2, max_scale: Vector2, duration: float) -> void:
	# Stop previous tween if it exists
	if scale_tween:
		scale_tween.kill()
		scale_tween = null

	# Create a new tween
	scale_tween = create_tween()

	# Tween up, then back down
	scale_tween.tween_property(polygon_2d, "scale", max_scale, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(polygon_2d, "scale", min_scale, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
