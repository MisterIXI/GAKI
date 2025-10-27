class_name LaserShot
extends Area2D

var settings: ProjectileSetting
@export var ray: RayCast2D
var lifetime: float
var base_velocity: Vector2
var source_body: Node2D

func init_laser(projectile_settings: ProjectileSetting, shooter: Node2D , initial_velocity: Vector2 = Vector2.ZERO):
	settings = projectile_settings
	base_velocity = initial_velocity
	source_body = shooter

func _ready():
	add_to_group("laser")
	if settings == null:
		push_warning("No settings given on spawn. Self destructing...")
		# queue_free()
		settings = ProjectileSetting.new()
		return
	ray.target_position = Vector2.RIGHT * settings.laser_velocity
	lifetime = settings.laser_lifetime

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	# move laser by laser_velocity/seconds
	position += transform.x.normalized() * settings.laser_velocity * delta + base_velocity * delta

func _on_body_entered(body: Node2D):
	# to prevent multiple collisions after moving
	if is_queued_for_deletion():
		return
	# exclude shooter
	if body == source_body:
		return
	# check if body can be damaged
	if body.is_in_group("has_health"):
		# get health component of body and damage it
		body.get_node(body.get_meta("health_path")).damage(settings.laser_damage)
	# if body.is_in_group("missile"):
	# 	var missile = body as Missile
	# 	missile.explode()
	# self destruct
	queue_free()
