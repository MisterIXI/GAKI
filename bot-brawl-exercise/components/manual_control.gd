@icon("res://assets/icons/node_steering.svg")
class_name ManualControl
extends Node

@export var is_enabled: bool = true
@onready var player: SpaceShip = get_parent()
var camera: Camera2D
var camera_zoom_tween: Tween
var camera_zoom = 1

const ZOOM_FACTOR = 0.1
const MAX_ZOOM = 3.5
const MIN_ZOOM = 0.3

func _ready():
	camera = get_node_or_null("../Camera2D")
	if not camera:
		push_error("No Camera found to control, disabling camera controls...")

func _physics_process(_delta):
	if not is_enabled:
		return
	player.targeting_point = player.get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			player.shoot_primary()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			player.shoot_secondary()
		if camera:
			if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP and mouse_event.pressed:
				var factor = clamp(camera_zoom * (1 + ZOOM_FACTOR), MIN_ZOOM, MAX_ZOOM)
				_zoom_camera_to(factor)
			elif mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and mouse_event.pressed:
				var factor = clamp(camera_zoom * (1 - ZOOM_FACTOR), MIN_ZOOM, MAX_ZOOM)
				_zoom_camera_to(factor)
			elif mouse_event.button_index == MOUSE_BUTTON_MIDDLE and mouse_event.pressed:
				_zoom_camera_to(1)
	elif event is InputEventKey:
		player.acceleration_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if event.is_action("boost"):
			player.is_boosting = event.pressed


func _zoom_camera_to(factor: float):
	if not camera:
		push_warning("Zoom camera called without camera, aborting...")
	if camera_zoom_tween:
		camera_zoom_tween.kill()
	camera_zoom_tween = camera.create_tween()
	camera_zoom_tween.tween_property(camera, "zoom", Vector2(factor, factor), 0.05)
	camera_zoom = factor