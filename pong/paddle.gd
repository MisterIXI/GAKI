class_name Paddle
extends CharacterBody2D
@export var speed: float = 400.0
@export var size: float = 120.0
## -1.0 down and 1.0 up
var movement: float = 0.0

func _physics_process(delta):
	if movement != 0.0:
		velocity.x = 0
		velocity.y = clampf(movement, -1.0, 1.0) * speed
		move_and_collide(velocity * delta)
		