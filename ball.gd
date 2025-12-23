extends CharacterBody2D
class_name Ball

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var slomo_timer: Timer = $SlomoTimer
@onready var hitmark_vignette: ColorRect = $CanvasLayer/HitmarkVignette
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var is_ball_one := false
@export var colour_ball_one := Color('#D8D8F6')
@export var colour_ball_two := Color('#B18FCF')
@export var speed := 75.0


# Stores the active Tween to prevent starting a new flash if one is already running
var current_flash_tween: Tween = null
var scale_tween = null

func _ready() -> void:
	# Set the position
	global_position.y = (get_viewport_rect().size.y/2)
	if is_ball_one:
		global_position.x = (get_viewport_rect().size.x/4) + (get_viewport_rect().size.y/2)
	else:
		global_position.x = (get_viewport_rect().size.x/4)

	# Set velocity
	velocity.x = -speed
	velocity.y = randi_range(-15, 15) # randomize that starting velocity a bit.

	# Set the correct colours
	polygon_2d.color = colour_ball_one if is_ball_one else colour_ball_two
	if is_ball_one:
		gpu_particles_2d.process_material.color = colour_ball_two
	else:
		gpu_particles_2d.process_material.color = colour_ball_one


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	# If there is a collision, bounce the ball and toggle the collided tile
	if collision:
		# Bounce the velocity to the ball collides
		velocity = velocity.bounce(collision.get_normal())
		

		# If the collision is with a tile, toggle it
		if collision.get_collider() is Tile:
			collision.get_collider().toggle(self)
			
			#slomo & fx
			trigger_vignette(hitmark_vignette.material as ShaderMaterial)
			Engine.time_scale = 0.2
			slomo_timer.start()
			
			#Call tweens when collision happens
			tween_polygon_pulse_once(Vector2(1,1), Vector2(1.5,1.5), 0.05)


func _get_collision_layer() -> int:
	return collision_layer


func _on_slomo_timer_timeout() -> void:
	Engine.time_scale = 1


func trigger_vignette(shader_material: ShaderMaterial, fade_time: float = 1.0) -> void:

	# Immediately set intensity to 1
	shader_material.set_shader_parameter("flicker_intensity", 1.0)

	# Tween to fade intensity back to 0 over fade_time seconds
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/flicker_intensity", 0.0, fade_time)


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
