class_name ManualControl
extends Node

@export var is_enabled: bool = true
@onready var player: PlayerShip = get_parent()

func _physics_process(_delta):
	if not is_enabled:
		return
	player.targeting_point = player.get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			player.shoot_guns()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			player.shoot_missiles()
	elif event is InputEventKey:
		player.acceleration_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if event.is_action("boost"):
			player.is_boosting = event.pressed