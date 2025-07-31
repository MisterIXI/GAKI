@tool

const METADATA_NAME := &"scene_tree_color"
const PROPERTY_NAME := StringName("metadata/" + METADATA_NAME)

const MAIN_ALPHA : float = 0.35
const CHILD_ALPHA : float = 0.15
const COLORS = [
	Color(0.88, 0.24, 0.24, 1), Color(0.88, 0.49, 0.24, 1), Color(0.88, 0.78, 0.24, 1), Color(0.44, 0.88, 0.24, 1), Color(0.24, 0.88, 0.56, 1),
	Color(0.24, 0.74, 0.88, 1), Color(0.44, 0.24, 0.88, 1), Color(0.88, 0.24, 0.52, 1), Color(0.54, 0.54, 0.54, 1), Color(0.15, 0.15, 0.15, 1)
]

const BTN_ICON : Texture2D = preload("res://addons/scenetree-palette/btn_icon.png")
const BTN_PRESSED_ICON : Texture2D = preload("res://addons/scenetree-palette/btn_icon_pressed.png")
const CLEAT_BTN_ICON : Texture2D = preload("res://addons/scenetree-palette/clear_btn_icon.png")


static func node_has_color(node: Node):
	var value = node.get_meta(METADATA_NAME, 0)
	return typeof(value) == TYPE_COLOR


static func get_child_of_type(node: Node, type: String, recursive: bool = false) -> Node:
	var l = node.find_children("", type, recursive, false)
	assert(len(l) == 1)
	return l[0]
