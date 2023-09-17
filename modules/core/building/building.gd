class_name Building
extends StaticBody2D


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel

@onready var top_layer_shape: CollisionShape2D = $CollisionShape2D
@onready var top_layer: BricksLayer


func _ready() -> void:
	_bricks_layers_signals_channel.layer_landed.connect(_append_layer)


func _append_layer(layer: BricksLayer) -> void:
	var new_building_layer = layer.collision_shape.duplicate(true) as CollisionShape2D
	add_child(new_building_layer)
	new_building_layer.global_position = layer.collision_shape.global_position
	new_building_layer.disabled = false
	top_layer_shape = layer.collision_shape
	top_layer = layer
