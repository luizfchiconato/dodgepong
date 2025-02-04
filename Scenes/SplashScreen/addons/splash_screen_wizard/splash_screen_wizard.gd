@tool
extends EditorPlugin


var EditorUI = preload("res://Scenes/SplashScreen/addons/splash_screen_wizard/editor_ui.gd")


var _inspector_plugin_editor_ui


func _enter_tree():
	_inspector_plugin_editor_ui = EditorUI.new()
	add_inspector_plugin(_inspector_plugin_editor_ui)


func _exit_tree():
	remove_inspector_plugin(_inspector_plugin_editor_ui)
