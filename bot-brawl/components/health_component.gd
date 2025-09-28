@icon("res://assets/icons/bootstrap/heart.svg")
class_name HealthComponent
extends Node2D

@export var health: float = 100.0:
	set(val):
		health = val
		health_changed.emit()
		if health <= 0 and not was_zero:
			health_zero.emit()
var was_zero: bool = false
signal health_changed
signal health_zero

func _ready():
	health_changed.connect(on_health_changed)
	health_zero.connect(on_health_zero)
	get_parent().add_to_group("has_health")
	get_parent().set_meta("health_path", name)

func on_health_zero():
	was_zero = true

func on_health_changed():
	if health >= 0 and was_zero:
		was_zero = false

func damage(value: float):
	health -= value