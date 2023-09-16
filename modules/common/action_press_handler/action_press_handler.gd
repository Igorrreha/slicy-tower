class_name ActionPressHandler
extends Node


signal action_pressed


@export var _action: StringName


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(_action):
		action_pressed.emit()
