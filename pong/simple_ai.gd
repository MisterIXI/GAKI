class_name SimpleAI
extends Node

@export var ball: PongBall
@onready var paddle: Paddle = get_parent()
@export var avoid_vibration: bool = true

func _physics_process(delta):
	if avoid_vibration:
		_chase_ball_no_vibration(delta)
	else:
		_chase_ball_simple()

## just move towards the ball
func _chase_ball_simple() -> void: 
	paddle.movement = ball.position.y - paddle.position.y

## try to not overshoot
func _chase_ball_no_vibration(delta: float) -> void:
	paddle.movement = (ball.position.y - paddle.position.y) / paddle.speed / delta
