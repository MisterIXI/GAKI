class_name PongBall
extends CharacterBody2D


func _ready():
	velocity = Vector2(200, 0)
	# velocity = velocity.rotated(randf() * PI * 2) # Randomize initial direction


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		# check if collided with a paddle
		var collider: Node = collision.get_collider()
		if collider.is_in_group("paddles"):
			handle_paddle_collision(collision)
		else:
			velocity = velocity.bounce(collision.get_normal())
	pass


func _handle_paddle_collision(collision: KinematicCollision2D) -> void:
	# if the ball hits a paddle, adjust the angle based on where it hit
	var paddle: Node2D = collider
	var paddle_center: Vector2 = paddle.global_position
	var hit_position: Vector2 = collision.get_position()
	var diff = hit_position.y - paddle_center.y
	print("Hit paddle with diff: ", diff)
	velocity = velocity.bounce(collision.get_normal())
	var magnitude: float = velocity.length()
	if diff > 0 and velocity.y < 0:
		velocity.y = diff
	elif diff < 0 and velocity.y > 0:
		velocity.y = -diff
	else:
		velocity.y += diff
	velocity = velocity.normalized() * (magnitude + abs(diff))

func _handle_goal_collision(collision: KinematicCollision2D) -> void:
	pass