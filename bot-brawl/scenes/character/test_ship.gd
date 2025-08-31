class_name TestShip
extends RigidBody2D

@export var nav_agent: NavigationAgent2D

var current_target: Vector2
var is_navigating: bool

var current_path
const SPEED = 1115

func _ready():
	print("Hello")

func _physics_process(delta):
	if is_navigating:
		nav_agent.get_next_path_position()
		linear_velocity += (nav_agent.get_next_path_position() - global_position).normalized() * SPEED * delta
		pass

func _input(event):
	if event is InputEventMouseButton:
		print("meh")
		var click: InputEventMouseButton = event
		print(click)
		if click.button_index == MouseButton.MOUSE_BUTTON_LEFT and click.pressed and not click.canceled:
			nav_agent.target_position = get_viewport().get_camera_2d().get_global_mouse_position()
			is_navigating = true
