@icon("res://assets/icons/lightning_bolt.svg")
class_name EnergyComponent
extends Node2D

@export var current_energy : float = 150:
	set(val):
		current_energy = val
		current_energy_changed.emit(current_energy)

signal current_energy_changed(new_value: float)
func _ready():
	get_parent().set_meta("energy_path", get_path())

