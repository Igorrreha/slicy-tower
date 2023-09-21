class_name ActionPressHandler
extends Node


signal action_pressed


@export var _action: StringName

var is_active: bool


func activate() -> void:
	is_active = true


func deactivate() -> void:
	is_active = false


func _input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed(_action):
		action_pressed.emit()
