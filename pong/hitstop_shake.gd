extends Camera2D

@export var ball: PongBall
@export var particle_system: CPUParticles2D
@export var curve: Curve

var constant_shake: float = 0.0

func _ready():
	# ball.ball_collision.connect(_on_ball_collision)
	pass


func _process(delta):
	if constant_shake == 0.0:
		offset = Vector2.ZERO
	else:
		var shake = Vector2(
			(randf_range(-1.0, 1.0) * constant_shake),
			(randf_range(-1.0, 1.0) * constant_shake)
		)
		offset += shake
		offset.x = clampf(offset.x, -10, 10)
		offset.y = clampf(offset.y, -10, 10)

func _on_ball_collision(collision: KinematicCollision2D) -> void:
	var point = collision.get_position()
	var normal = collision.get_normal()
	var impact_strength = ball.velocity.length() / 3000.0
	impact_strength = curve.sample(impact_strength)
	var duration = impact_strength
	if impact_strength > 0.02:
		particle_system.amount = int(impact_strength * 50)
		# particle_system.scale = Vector2(impact_strength, impact_strength)
		particle_system.scale = Vector2.ONE * clampf(impact_strength * 1.5, 0, 1.0)
		particle_system.global_position = point
		particle_system.rotation = normal.angle()
		particle_system.restart()
		particle_system.emitting = true
	Engine.time_scale = 0.001
	constant_shake = impact_strength * 50.0
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(Engine, "time_scale", 1.0, duration)
	tween.parallel()
	tween.tween_property(self, "constant_shake",0.0, duration)
	tween.tween_property(self, "zoom", Vector2.ONE, duration)
	tween.tween_property(self, "global_position", Vector2(1280.0/2.0, 720.0/2.0), duration)
	tween.finished.connect(func():
		global_position = Vector2(1280.0/2.0, 720.0/2.0)
		zoom = Vector2.ONE
		offset = Vector2.ZERO)
	tween.play()
	var zoom_factor = 1.0 + impact_strength
	zoom_factor = clampf(zoom_factor, 1.0, 1.1)
	# zoom = Vector2.ONE * zoom_factor
	# global_position = global_position.lerp((point - global_position) / 2.0 + global_position, (zoom_factor - 1.0) * 1.8)
	print("Vel_mag: ", ball.velocity.length(), " | Impact Strength: ", impact_strength, " | Duration: ", duration)
