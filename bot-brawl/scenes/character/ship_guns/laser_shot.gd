class_name LaserShot
extends Area2D


var settings: ProjectileSetting
@export var ray: RayCast2D


func _ready():
	if settings == null:
		push_warning("No settings given on spawn. Self destructing...")
		# queue_free()
		settings = ProjectileSetting.new()
		return
	ray.target_position = Vector2.RIGHT * settings.laser_velocity

func _physics_process(delta):
	# move laser by laser_velocity/seconds
	position += transform.x.normalized() * settings.laser_velocity * delta



func _on_body_entered(body: Node2D):
	# to prevent multiple collisions after moving
	if is_queued_for_deletion():
		return
	# check if body can be damaged
	if body.is_in_group("has_health"):
		# get health component of body and damage it
		body.get_node(body.get_meta("health_path")).damage(settings.laser_damage)
	# self destruct
	queue_free()
