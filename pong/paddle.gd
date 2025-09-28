class_name Paddle
extends CharacterBody2D
@export var speed: float = 400.0
@export var size: float = 120.0
## -1.0 down and 1.0 up
var movement: float = 0.0

func _ready():
	var resource_id := get_rid()
	PhysicsServer2D.body_set_continuous_collision_detection_mode(resource_id, PhysicsServer2D.CCD_MODE_CAST_RAY)

func _physics_process(delta):
	if movement != 0.0:
		velocity.x = 0
		velocity.y = clampf(movement, -1.0, 1.0) * speed
		move_and_collide(velocity * delta)
		