extends StaticBody2D


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel


func _ready() -> void:
	_bricks_layers_signals_channel.layer_landed.connect(_append_layer)


func _append_layer(layer: BricksLayer) -> void:
	layer.collision_shape.reparent(self)
