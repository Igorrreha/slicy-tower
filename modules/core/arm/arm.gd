@tool
extends Node2D


@export var _signals_channel: ArmSignalsChannel

@onready var _grab_point: Node2D = %GrabPoint
@onready var _grabber: RemoteTransform2D = %Grabber


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_signals_channel.grabber_relax_requested.connect(_relax_grabber)
	_signals_channel.grabber_grab_requested.connect(_grab_object)


func _draw() -> void:
	draw_line(Vector2.ZERO, _grab_point.position, Color.TAN, 10)


func _relax_grabber() -> void:
	_grabber.remote_path = ""
	_signals_channel.grabber_relaxed.emit()


func _grab_object(object_to_grab: Node2D) -> void:
	_grabber.remote_path = _grabber.get_path_to(object_to_grab)
	object_to_grab.position = Vector2.ZERO
	object_to_grab.rotation = 0
