class_name PredictiveAI
extends Node2D
 
@export var ball: PongBall
#-- detector_layer ist für den Raycast als Bitmaske für die Layer.
#-- Eine Seite braucht Layer 1 und 2, die andere 1 und 3
@export var detector_layer: int = 0b0011
@onready var paddle: Paddle = get_parent()
signal target_predicted(target_height: float)
 
var target_y: float = 720.0 / 2.0 # Default to center of the screen
var raycast_path: Array = []
 
func _physics_process(delta):
	# go towards the target Y position
	paddle.movement = (target_y - paddle.position.y) / paddle.speed / delta
 
func _on_ball_collision(collision: KinematicCollision2D) -> void:
	var collider: Node = collision.get_collider()
#-- Wenn der Ball das andere Paddle trifft, rechne einen neue Prediction aus
	# check if the ball just collided with the other paddle
	if collider.is_in_group("paddles") and collider != paddle:
		raycast_path.clear()
		# raycast and bounce until hit a detection layer
		var curr_pos: Vector2 = collision.get_position()
		raycast_path.append(curr_pos)
		var direction: Vector2 = ball.velocity.normalized()
		calc_new_target_y(curr_pos, direction, collider)
		queue_redraw()
#-- Wenn der Ball das eigene Paddle trifft, lösche die Visualisierung
#-- und zurück auf neutrale Position
	elif collider == paddle:
		# if the ball hit itself, just set the target to the center
		target_y = 720.0 / 2.0
		raycast_path.clear()
		# print("Ball hit itself, resetting target to center.")
		queue_redraw()
 
#-- Bei Kickoff muss getestet werden ob der Ball auf das eigene Paddle zugeht
#-- dafür wird verglichen ob der Ball links vom Paddle ist und nach rechts geht
#-- und umgekehrt
func _on_kickoff() -> void:
	var ball_left_of_paddle: bool = ball.global_position.x < paddle.global_position.x
	if ((ball_left_of_paddle and ball.velocity.x > 0.0)
		or
		(not ball_left_of_paddle and ball.velocity.x < 0.0)):
		calc_new_target_y(
			ball.global_position,
			ball.velocity.normalized(),
			null
		)
 
#-- Um eine Prediction zu machen werden raycasts geschossen bis eine Wand getroffen wird 
#-- und reflektiert. Das wirdd wiederholt bis ein detector getroffen wird.
func calc_new_target_y(start_pos: Vector2, start_dir: Vector2, prev_collider: Node) -> void:
	var curr_pos: Vector2 = start_pos
	var direction: Vector2 = start_dir
	var emergency_counter: int = 0
	var ray_length: float = 2000.0 # Arbitrary long distance
	var is_finished: bool = false
	var ray_end: Vector2 = start_pos + start_dir * ray_length
	var space_state = paddle.get_world_2d().direct_space_state
	# fallback to paddle if no previous collider is provided
	var last_collider: Node = prev_collider if prev_collider else paddle
	while not is_finished:
			emergency_counter += 1
			if emergency_counter > 50:
				push_error("Emergency counter exceeded 100. Stopping raycast to prevent infinite loop.")
				return
			# print("dir: ", direction)
			var query = PhysicsRayQueryParameters2D.create(
				curr_pos,
				ray_end,
				detector_layer,
				[last_collider, paddle, ball],
				
			)
			query.hit_from_inside = false
			var result = space_state.intersect_ray(query)
			if result.is_empty():
				push_error("Raycast did not hit anything. Aborting...")
				return
			if result["collider"].is_in_group("detectors"):
				is_finished = true
				target_y = result["position"].y
				target_y = paddle.get_parent().to_local(Vector2(0, target_y)).y
				target_predicted.emit(result["position"].y)
				raycast_path.append(result["position"])
				target_y += (randf() - 0.5) * 40 # Add some randomness to the target Y position
				# print("target_y set to: ", target_y)
			else:
				if result["normal"] == Vector2.ZERO:
					# print("pos: ", result["position"])
					push_error("Raycast hit a collider with no normal. Aborting...")
					return
				curr_pos = result["position"]
				direction = direction.bounce(result["normal"])
				ray_end = curr_pos + direction * ray_length
				# print("bounce at: ", curr_pos)
				raycast_path.append(curr_pos)
				last_collider = result["collider"]
 
#-- Mit der Draw funktion wird direkt auf das malen der Node2D zugegriffen
#-- hier wird der zuvor gespeicherte predictive path gemalt
#-- außerdem werden Start und Ende markiert.
func _draw():
	if raycast_path.size() > 0:
		var draw_arr: Array = []
		for point in raycast_path:
			draw_arr.append(point)
		# print(raycast_path)
		for i in range(raycast_path.size() - 1):
			draw_line(draw_arr[i], draw_arr[i + 1], Color(1, 0, 0), 3)
		draw_circle(draw_arr[0], 5, Color(0, 1, 0)) # Start point
		draw_circle(draw_arr[-1], 5, Color(0, 0, 1)) # End point