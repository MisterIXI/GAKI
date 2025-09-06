extends AIController2D
class_name TBPushAIController
@onready var paddle: Paddle = get_parent()
@onready var pong_match: PongMatch = get_parent().get_parent()
@export var is_on_left_side: bool = true
@export var other_predictive: PredictiveAI
var side_mult: int = 1
var is_success: bool = false

var last_closest_dist_change: int = 0
var closest_dist: float = 0
var closest_to_ball: float = 0
var ball_in_button_area: bool = false
var has_been_close_to_ball: bool = false
var last_ball_pos_glob: Vector3 = Vector3.ZERO
const FOV = 120.0
const BALL_MIDDLE = 20.0

var turns_made: int = 0
var angle_accum: float = 0

func _ready():
	super._ready()
	if not is_on_left_side:
		side_mult = -1
	pong_match.goal.connect(on_goal)
	pong_match.ball.ball_collision.connect(on_ball_collision)
	other_predictive.target_predicted.connect(reward_on_cornering)

func reward_on_cornering(target_y: float): ## local_ball_pos_and_wall_dist_fixed_corner_reward
	var local_y = paddle.to_local(Vector2(0, target_y)).y
	reward += max(0, max(
		5 - (local_y * 15 / 720.0),
		5 - ((720 - local_y) * 15 / 720)
		))


func get_obs() -> Dictionary:
	var obs = [ ## local_ball_pos
		paddle.to_local(pong_match.ball.global_position).x * side_mult / 1280.0,
		paddle.to_local(pong_match.ball.global_position).y / 720.0,
		pong_match.ball.velocity.x * side_mult / 1280.0,
		pong_match.ball.velocity.y / 720.0,
		paddle.position.y / 720.0,
	]
	# var obs = [ ## local_ball_pos_and_wall_dist
	# 	paddle.to_local(pong_match.ball.global_position).x * side_mult / 1280.0,
	# 	paddle.to_local(pong_match.ball.global_position).y / 720.0,
	# 	pong_match.ball.velocity.x * side_mult / 1280.0,
	# 	pong_match.ball.velocity.y / 720.0,
	# 	min(abs(720-pong_match.ball.position.y), pong_match.ball.position.y),
	# 	paddle.position.y / 720.0,
	# ]
	# var obs = [ ## local_ball_pos_and_wall_dist_fixed && local_ball_pos_and_wall_dist_fixed_corner_reward
	# 	paddle.to_local(pong_match.ball.global_position).x * side_mult / 1280.0,
	# 	paddle.to_local(pong_match.ball.global_position).y / 720.0,
	# 	pong_match.ball.velocity.x * side_mult / 1280.0,
	# 	pong_match.ball.velocity.y / 720.0,
	# 	pong_match.ball.position.y /720.0, # distance to top wall
	# 	(720 - pong_match.ball.position.y) / 720.0, # distance to bottom wall
	# 	paddle.position.y / 720.0,
	# ]
	# var obs = [ ## pong_ai_with_vel
	# 	pong_match.ball.position.x * side_mult / 1280.0,
	# 	pong_match.ball.position.y / 720.0,
	# 	pong_match.ball.velocity.x * side_mult / 1280.0,
	# 	pong_match.ball.velocity.y / 720.0,
	# 	paddle.position.y / 720.0,
	# ]
	# var obs = [ ## pong_ai_with_enemy_pos
	# 	pong_match.ball.position.x * side_mult / 1280.0,
	# 	pong_match.ball.position.y / 720.0,
	# 	pong_match.ball.velocity.x * side_mult / 1280.0,
	# 	pong_match.ball.velocity.y / 720.0,
	# 	paddle.position.y / 720.0,
	# 	pong_match.paddle_right.position.y / 720.0 if is_on_left_side else pong_match.paddle_left.position.y / 720.0
	# ]
	return {"obs": obs}


func get_reward() -> float:

	return reward


func get_action_space() -> Dictionary:
	return {
		"paddle_movement": {"size": 1, "action_type": "continuous"},
	}


func set_action(action) -> void:
	paddle.movement = action["paddle_movement"][0]

func _physics_process(_delta):
	# n_steps += 1
	# if n_steps > reset_after:
	# 	# print("N_steps: ", n_steps)
	# 	needs_reset = true
	# 	is_success = false
	# 	done = true
	# 	# reward += env.settings.reward_failure
	if needs_reset:
		# print("Needs_reset: ", needs_reset)
		reset()

func reset():
	n_steps = 0
	needs_reset = false
	pong_match.reset_ball(randf()>0.5)
	pong_match.reset_paddle_pos()

func get_info() -> Dictionary:
	if done:
		return {
			"is_success": is_success,
		}
	return {}

func on_goal(goal_on_left_side: bool) -> void:
	if goal_on_left_side != is_on_left_side:
		reward += 10
		is_success = true
	else:
		reward -= 10
		is_success = false
	done = true
	needs_reset = true

func on_ball_collision(node: Node) -> void:
	# when succesfully bouncing ball, get reward
	if node == paddle:
		reward += 1