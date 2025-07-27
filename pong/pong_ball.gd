class_name PongBall
extends CharacterBody2D
const BOUNCE_ANGLE: float = 45

signal ball_collision(collision: KinematicCollision2D)

func _ready():
	velocity = Vector2(300, 0)

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		# check if collided with a paddle
		var collider: Node = collision.get_collider()
		if collider.is_in_group("paddles"):
			_handle_paddle_collision(collision)
			ball_collision.emit(collision)
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
	var magnitude: float = velocity.length()
	velocity = collision.get_normal() * (magnitude + abs(diff) * 100.0)
	if velocity.x > 0:
		# when going left
		velocity = velocity.rotated(deg_to_rad(BOUNCE_ANGLE * diff))
	else:
		# when going right
		velocity = velocity.rotated(deg_to_rad(-BOUNCE_ANGLE * diff))
