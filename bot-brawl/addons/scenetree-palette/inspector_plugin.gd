extends EditorInspectorPlugin

var editor_inspector: Node
var editor_scale = 1.0
var undo_redo: EditorUndoRedoManager
var node : Node
var btns = []

const Util = preload("util.gd")
signal color_changed

func _can_handle(object):
	return object is Node


func _parse_end(object):
	if not object is Node:
		return
	node = object

	# Add a spacer to separate the custom controls from the default controls
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 8) * editor_scale
	add_custom_control(spacer)

	# Adds a label to the inspector
	var label = Label.new()
	label.text = "SceneTree Palette"
	label.add_theme_font_size_override("font_size", 16 * editor_scale)
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_custom_control(label)

	# Adds the grid container to the inspector
	var grid_container = GridContainer.new()
	grid_container.columns = 5
	grid_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_custom_control(grid_container)


	# Adds the color buttons to the grid container
	btns.clear()
	for color in Util.COLORS:
		var btn = _create_color_button(color)
		btns.append(btn)
		btn.pressed.connect(_on_color_button_pressed.bind(btn))
		grid_container.add_child(btn)
	_select_current_button()


	# Add a spacer to separate the custom controls from the default controls
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 8) * editor_scale
	add_custom_control(spacer2)


	# Adds the clear button to the inspector
	var clear_btn = Button.new()
	clear_btn.text = "Clear Color"
	clear_btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	clear_btn.icon = Util.CLEAT_BTN_ICON
	clear_btn.focus_mode = Control.FOCUS_NONE
	clear_btn.theme_type_variation = "InspectorActionButton"
	clear_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_custom_control(clear_btn)
	clear_btn.pressed.connect(_on_clear_button_pressed)


func _create_color_button(color : Color) -> Button:
	var btn = Button.new()
	btn.icon = Util.BTN_ICON
	btn.add_theme_color_override("icon_normal_color", color)
	btn.add_theme_color_override("icon_hover_color", color)
	btn.add_theme_color_override("icon_pressed_color", color)
	btn.focus_mode = Control.FOCUS_NONE
	return btn


func _on_color_button_pressed(btn : Button):
	var color = btn.get_theme_color("icon_normal_color")

	if Util.node_has_color(node):
		node.set_meta(Util.METADATA_NAME, Color(color, Util.MAIN_ALPHA))
	else:
		undo_redo.create_action("Set Custom Color")
		undo_redo.add_do_method(node, &"set_meta", Util.METADATA_NAME, Color(color, Util.MAIN_ALPHA))
		undo_redo.add_undo_method(node, &"remove_meta", Util.METADATA_NAME)
		undo_redo.commit_action()
	_select_current_button()


func _select_current_button():
	if not btns:
		return
	color_changed.emit()
	for btn in btns:
		if Util.node_has_color(node):
			var color = node.get_meta(Util.METADATA_NAME)
			if Color(btn.get_theme_color("icon_normal_color"), Util.MAIN_ALPHA) == color:
				btn.icon = Util.BTN_PRESSED_ICON
			else:
				btn.icon = Util.BTN_ICON
		else:
			btn.icon = Util.BTN_ICON


func _on_clear_button_pressed():
	if Util.node_has_color(node):
		undo_redo.create_action("Remove Custom Color")
		undo_redo.add_do_method(node, &"remove_meta", Util.METADATA_NAME)
		undo_redo.commit_action()
	_select_current_button()
