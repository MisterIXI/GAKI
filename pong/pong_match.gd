class_name PongMatch
extends Node2D

@export var ball: PongBall
@export var paddle_left: Paddle
@export var paddle_right: Paddle


@export var label_a: Label
@export var label_b: Label
var score_a: int = 0
var score_b: int = 0

signal kickoff
signal goal(has_player_left_one: bool)

func _ready():
	reset_ball(true)

func _on_goal_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		score_b += 1
		label_b.text = str("%02d" % score_b)
		reset_ball(true)
		print("Goal for Player B! Score: ", score_b)
		goal.emit(true)

func _on_goal_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		score_a += 1
		label_a.text = str("%02d" % score_a)
		reset_ball(false)
		print("Goal for Player A! Score: ", score_a)
		goal.emit(false)

func reset_paddle_pos() -> void:
	paddle_left.position.y = 720 / 2.0
	paddle_right.position.y = 720 / 2.0

func reset_ball(towards_left: bool = true) -> void:
	ball.position = Vector2(1280.0/2.0, 720.0/2.0) + Vector2.UP * (randf() - 0.5) * 100
	ball.velocity = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	if towards_left:
		ball.velocity = Vector2(-300, 0)
	else:
		ball.velocity = Vector2(300, 0)
	# rotate by 10% of 180 degrees
	ball.velocity = ball.velocity.rotated(randf() * PI * 0.1)
	kickoff.emit()
	
