extends Node


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel
@export var _arm_signals_channel: ArmSignalsChannel
@export var _bricks_layers_container: Node

@export var _bricks_layer_tscn: PackedScene
@export var _brick_tscn: PackedScene
@export var _brick_colors: PackedColorArray


func _ready() -> void:
	_bricks_layers_signals_channel.layer_broken.connect(_spawn_bricks_layer.unbind(1))
	_bricks_layers_signals_channel.layer_landed.connect(_spawn_bricks_layer.unbind(1))
	_spawn_bricks_layer()


func _spawn_bricks_layer() -> void:
	var new_layer = _bricks_layer_tscn.instantiate() as BricksLayer
	_bricks_layers_container.add_child(new_layer)
	new_layer.setup(_create_brick(), _create_brick(), _create_brick())
	
	_arm_signals_channel.grabber_grab_requested.emit(new_layer)


func _create_brick() -> Brick:
	var new_brick = _brick_tscn.instantiate() as Brick
	new_brick.paint(_brick_colors[randi() % _brick_colors.size()])
	return new_brick
