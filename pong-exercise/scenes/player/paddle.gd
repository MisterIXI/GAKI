class_name Paddle
extends CharacterBody2D

## speed of paddle movement
@export var speed: float = 400.0
## size of paddle (used for ball calculation later)
const size: float = 120.0
## movement direction: -1.0 down and 1.0 up
var movement: float = 0.0

func _physics_process(delta):
	# If Movement is not zero
	if movement != 0.0:
		velocity.x = 0
		# set vertical velocity and clamp movement in case it's set incorrectly
		velocity.y = clampf(movement, -1.0, 1.0) * speed
		# move until hitting an obstacle
		move_and_collide(velocity * delta)
