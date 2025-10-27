class_name SpaceShip
extends RigidBody2D

@export var speed: float = 500
@export var acceleration: float = 1000

var is_thrusting : bool = false:
	set(val):
		is_thrusting = val
		thrusting_changed.emit(is_thrusting)
var is_boosting : bool = false:
	set(val):
		is_boosting = val
		boosting_changed.emit(is_boosting)

var targeting_point: Vector2 = Vector2.ZERO
var acceleration_input: Vector2 = Vector2.ZERO

signal thrusting_changed(is_thrusting: bool)
signal boosting_changed(is_boosting: bool)
signal primary_fire_triggered()
signal secondary_fire_triggered()
signal damaged(damage: float)

func _ready():
	add_to_group("ship")

func _physics_process(_delta):
	# handle acceleration input
	apply_central_force(acceleration_input * acceleration)
	# handle aiming
	look_at(targeting_point)
	rotation_degrees += 90

	check_for_thrusting_state()

func check_for_thrusting_state() -> void:
	if acceleration_input.is_zero_approx() != not is_thrusting:
		is_thrusting = !is_thrusting
		thrusting_changed.emit(is_thrusting)

func shoot_primary():
	primary_fire_triggered.emit()

func shoot_secondary():
	secondary_fire_triggered.emit()

func take_damage(damage: float):
	damaged.emit(damage)