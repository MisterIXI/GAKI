class_name PongBall
extends CharacterBody2D
const BOUNCE_ANGLE: float = 45

func _ready():
	velocity = Vector2(200, 0)

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		# check if collided with a paddle
		var collider: Node = collision.get_collider()
		if collider.is_in_group("paddles"):
			_handle_paddle_collision(collision)
		else:
			velocity = velocity.bounce(collision.get_normal())
	pass

func _handle_paddle_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider() is not Paddle:
		push_warning("Collision with non-Paddle object: %s" % collision.get_collider().name)
		return
	# if the ball hits a paddle, adjust the angle based on where it hit
	var paddle: Paddle = collision.get_collider()
	var paddle_center: Vector2 = paddle.global_position
	var hit_position: Vector2 = collision.get_position()
	var diff = hit_position.y - paddle_center.y
	diff = diff / (paddle.size / 2.0)
	velocity = velocity.bounce(collision.get_normal())
	var magnitude: float = velocity.length()
	velocity = velocity.normalized() * (magnitude + abs(diff))
	# only rotate if angle not already too extreme
	var vel_angle_deg: float = rad_to_deg(velocity.angle())
	print("Ball velocity angle: %.2f degrees" % vel_angle_deg)
	if (
		# between -40 and 40 (towards right)
		(vel_angle_deg > -40.0 and vel_angle_deg < 40.0) or
		# between 140 and -140 (towards left)
		(vel_angle_deg > 140.0 or vel_angle_deg < -140.0)
	):
		# rotate by diff
		velocity = velocity.rotated(deg_to_rad(diff * BOUNCE_ANGLE))
		print("Rotated ball by %.2f degrees" % (diff * BOUNCE_ANGLE))