@icon("res://assets/icons/heart.svg")
class_name HealthComponent
extends Node2D

@export var health: float = 100.0:
	set(val):
		health = val
		health_changed.emit()
		if health <= 0 and not was_zero:
			health_zero.emit()
var health_percentage: float:
	get():
		return health / initial_health
var was_zero: bool = false
var initial_health: float
signal health_changed
signal health_zero

func _ready():
	health_changed.connect(on_health_changed)
	health_zero.connect(on_health_zero)
	get_parent().add_to_group("has_health")
	get_parent().set_meta("health_path", get_path())
	initial_health = health

func on_health_zero():
	was_zero = true
	print("ded")

func on_health_changed():
	if health >= 0 and was_zero:
		was_zero = false

func damage(value: float):
	health = clampf(health - value, 0.0, initial_health)
