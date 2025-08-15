@tool
extends EditorPlugin

var inspector_plugin: EditorInspectorPlugin
var scenedock_editor: Node
var scenedock_tree: Tree

const Util = preload("util.gd")


func _enter_tree():
	var base_control = get_editor_interface().get_base_control()
	var scenedock = Util.get_child_of_type(base_control, "SceneTreeDock", true)
	scenedock_editor = Util.get_child_of_type(scenedock, "SceneTreeEditor")
	scenedock_tree = Util.get_child_of_type(scenedock_editor, "Tree")

	inspector_plugin = preload("res://addons/scenetree-palette/inspector_plugin.gd").new()
	inspector_plugin.editor_scale = get_editor_interface().get_editor_scale()
	inspector_plugin.editor_inspector = get_editor_interface().get_inspector()
	inspector_plugin.undo_redo = get_undo_redo()
	add_inspector_plugin(inspector_plugin)
	inspector_plugin.color_changed.connect(process_scenedock)
	scenedock_tree.property_list_changed.connect(process_scenedock)
	scenedock_tree.mouse_exited.connect(process_scenedock)
	scenedock_tree.mouse_entered.connect(process_scenedock)
	scenedock_tree.item_selected.connect(process_scenedock)


func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
	scenedock_editor.call("update_tree")


func process_scenedock():
	var current_item: TreeItem = scenedock_tree.get_root()
	while current_item:
		process_item(current_item)
		current_item = current_item.get_next_visible()


func process_item(item: TreeItem):
	var nodepath: NodePath = item.get_metadata(0)
	var node: Node = scenedock_tree.get_node_or_null(nodepath)
	if not node:
		return

	if Util.node_has_color(node):
		var color = node.get_meta(Util.METADATA_NAME, Color.TRANSPARENT)
		item.set_custom_bg_color(0, color)
	else:
		item.clear_custom_bg_color(0)
		var parent = item.get_parent()
		while parent:
			var parent_node = scenedock_tree.get_node_or_null(parent.get_metadata(0))
			if Util.node_has_color(parent_node):
				var color = parent_node.get_meta(Util.METADATA_NAME, Color.TRANSPARENT)
				item.set_custom_bg_color(0, Color(color, Util.CHILD_ALPHA))
				break
			parent = parent.get_parent()
