class_name HealthBar
extends ProgressBar

var hp_comp_parent: Node2D
var hp_comp: HealthComponent
var hp_offset: Vector2

func _ready():
	hp_comp = get_parent()
	hp_comp_parent = hp_comp.get_parent()
	hp_offset = hp_comp.position
	hp_comp.top_level = true
	hp_comp.health_changed.connect(_on_health_changed)
	_on_health_changed()

func _process(_delta):
	hp_comp.global_position = hp_comp_parent.global_position + hp_offset

func _on_health_changed():
	value = hp_comp.health_percentage * 100
	if value >= 100:
		hide()
	elif not visible:
		show()


