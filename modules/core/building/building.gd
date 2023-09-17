class_name Building
extends StaticBody2D


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel

@onready var top_layer_shape: CollisionShape2D = $CollisionShape2D
@onready var top_layer: BricksLayer


func _ready() -> void:
	_bricks_layers_signals_channel.layer_landed.connect(_append_layer)


func _append_layer(layer: BricksLayer) -> void:
	layer.collision_shape.reparent(self)
	top_layer_shape = layer.collision_shape
	top_layer = layer
