class_name PongBall
extends CharacterBody2D
const BOUNCE_ANGLE: float = 45
 
#-- Signal bei Paddle-Ball Kollision worauf Effekte oder KIs reagieren können
signal ball_collision(collision: KinematicCollision2D)
 
#-- Start Geschwindigkeit geben (primär zum testen am Anfang)
func _ready():
	velocity = Vector2(300, 0)
 
func _physics_process(delta):
#-- Solange gerade aus bewegen bis eine Kollision auftritt
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
#-- Unterscheidung zwischen Paddle und anderem damit die Paddle auch Zielen können
	if collision:
		# check if collided with a paddle
		var collider: Node = collision.get_collider()
		if collider.is_in_group("paddles"):
			# make special bounce to make aiming possible
			_handle_paddle_collision(collision)
			ball_collision.emit(collision)
		else:
			# bounce normally
			velocity = velocity.bounce(collision.get_normal())
 
func _handle_paddle_collision(collision: KinematicCollision2D) -> void:
#-- extra Fehlerbehandlung falls die Gruppe "Paddle" fälschlich gesetzt wird
	if collision.get_collider() is not Paddle:
		push_warning("Collision with non-Paddle object: %s" % collision.get_collider().name)
		return
#-- Lustige Mathe um das Bounce verhalten ähnlich zu Breakout zu machen
#-- Nur bedingt das originale PONG verhalten, aber macht es interessanter
#-- Großteil des Codes kann weggelassen werden ohne dieses Sonderverhalten
	# if the ball hits a paddle, adjust the angle based on where it hit
	var paddle: Paddle = collision.get_collider()
	var paddle_center: Vector2 = paddle.global_position
	var hit_position: Vector2 = collision.get_position()
	# calculate how far up or down the paddle the ball collided
	var diff = hit_position.y - paddle_center.y
	diff = diff / (paddle.size / 2.0)
	var magnitude: float = velocity.length()
	velocity = collision.get_normal() * (magnitude + abs(diff) * 100.0)
#-- Der Vektor wird in eine Richtung rotiert um den gesteuerten Bounce zu machen
	if velocity.x > 0:
		# when going left
		velocity = velocity.rotated(deg_to_rad(BOUNCE_ANGLE * diff))
	else:
		# when going right
		velocity = velocity.rotated(deg_to_rad(-BOUNCE_ANGLE * diff))