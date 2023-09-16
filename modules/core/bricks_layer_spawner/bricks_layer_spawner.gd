extends Node


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel
@export var _arm_signals_channel: ArmSignalsChannel
@export var _bricks_container: Node

@export var _bricks_layer_tscn: PackedScene


func _ready() -> void:
	_bricks_layers_signals_channel.layer_broken.connect(_spawn_bricks_layer.unbind(1))
	_bricks_layers_signals_channel.layer_landed.connect(_spawn_bricks_layer.unbind(1))
	_spawn_bricks_layer()


func _spawn_bricks_layer() -> void:
	var new_layer = _bricks_layer_tscn.instantiate()
	_bricks_container.add_child(new_layer)
	
	_arm_signals_channel.grabber_grab_requested.emit(new_layer)
