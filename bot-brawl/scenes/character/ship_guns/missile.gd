class_name Missile
extends RigidBody2D

@export var draw_target_debug: bool = true
signal thrusting_changed(is_thrusting)
var settings: ProjectileSetting
var lifetime: float
var base_velocity: Vector2
var source_body: Node2D
var fuel: float
var visible_targets: Array[Node2D]
@onready var detector: Area2D = $ShipDetector
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles
var is_burnt_out: bool = false
var is_boosting: bool = false
var current_target: Node2D:
	set(val):
		current_target = val
		queue_redraw()

func init_missile(projectile_settings: ProjectileSetting, shooter: Node2D, initial_velocity: Vector2 = Vector2.ZERO):
	await ready
	settings = projectile_settings
	base_velocity = initial_velocity
	source_body = shooter
	# shrink/grow detection polygon according to settings
	var detector_polygon = detector.get_child(0) as CollisionPolygon2D
	var detector_factor = settings.detector_distance / 60.0
	detector_polygon.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(-60, -60) * detector_factor,
		Vector2(60, -60) * detector_factor,
		]
	)
	# set initial setting values
	fuel = settings.fuel_duration

func _ready():
	add_to_group("missile")
	var col_layer = collision_layer
	var col_mask = collision_mask
	collision_layer = 0
	collision_mask = 0
	get_tree().create_timer(1).timeout.connect(func():
		collision_layer = col_layer
		collision_mask = col_mask
		is_boosting = true
		thrusting_changed.emit(true)
	)
	apply_impulse(global_transform.x * 300)
	pass

func explode(deal_damage = true):
	if is_queued_for_deletion():
		return

	# change explosion particles to be independent from missile
	remove_child(explosion_particles)
	get_parent().add_child(explosion_particles)
	explosion_particles.global_position = global_position
	# handle explosion
	if deal_damage:
		var space_state = get_world_2d().direct_space_state
		var shape = CircleShape2D.new()
		shape.radius = settings.explosion_radius
		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = shape
		query.transform = query.transform.translated(global_position)
		query.collide_with_bodies = true
		query.collide_with_areas = false
		query.exclude = [self]
		var results = space_state.intersect_shape(query)
		for result in results:
			var node: Node = result.collider
			if node.is_in_group("has_health"):
				var health_comp: HealthComponent = node.get_node(node.get_meta("health_path"))
				health_comp.damage(settings.explosion_damage)
	# make the one shot particles emit
	explosion_particles.emitting = true
	# adjust visuals to explosion radius
	explosion_particles.emission_sphere_radius = settings.explosion_radius
	explosion_particles.scale_amount_min *= settings.explosion_radius / 50
	explosion_particles.scale_amount_max *= settings.explosion_radius / 50
	# make explosion particles delete themselves after emission finished
	explosion_particles.finished.connect(explosion_particles.queue_free.bind())
	queue_free()

func _physics_process(delta):
	if is_burnt_out:
		return
	if not is_boosting:
		return
	fuel -= delta
	# check if rocket is out of fuel
	if fuel <= 0.0:
		is_burnt_out = true
		thrusting_changed.emit(false)
		current_target = null
		queue_redraw()
		# explode in 2 seconds if it didn't already happen
		get_tree().create_timer(2).timeout.connect(
		func():
			if self:
				self.explode()
		)
		return
	# get closest target to aim at
	for body: Node2D in visible_targets:
		if not current_target or current_target.global_position.distance_squared_to(global_position) < body.global_position.distance_squared_to(global_position):
			current_target = body
	if visible_targets.is_empty():
		current_target = null
	# aim towards target
	if current_target:
		queue_redraw()
		## PID like aiming
		var target_dir = (current_target.global_position - global_position).normalized()
		var target_error = target_dir.angle() - global_rotation
		target_error = wrapf(target_error, -PI, PI)
		var proportional_torque = target_error * settings.turning_gain
		var damping_torque = - angular_velocity * settings.turning_damp
		apply_torque(proportional_torque + damping_torque)

		var missile_angle = global_transform.x.angle()
		var vel_angle = linear_velocity.angle()
		var angle_diff = wrapf(missile_angle - vel_angle, -PI, PI)
		var rotation_amount = clampf(angle_diff, -settings.velocity_alignment_rate, settings.velocity_alignment_rate)
		linear_velocity = linear_velocity.rotated(rotation_amount)
	else:
		apply_torque(-angular_velocity * 0.8)
	# accelerate
	if current_target:
		apply_central_force(global_transform.x * settings.boosting_strength)
	else:
		# only apply half acceleration without a target (be "idle")
		apply_central_force(global_transform.x * settings.boosting_strength * 0.5)

func _on_ship_detector_body_entered(body: Node2D):
	# ignore self
	if body == self:
		return
	if body.is_in_group("ship"):
		visible_targets.append(body)

func _on_ship_detector_body_exited(body: Node2D):
	if body in visible_targets:
		visible_targets.erase(body)

func _draw():
	if current_target and draw_target_debug:
		draw_line(Vector2.ZERO, to_local(current_target.global_position), Color(0,1,0,0.5), 5)

func _on_body_entered(_body: Node):
	explode()
