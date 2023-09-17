class_name Building
extends StaticBody2D


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel
@export var _layer_offset_impact_curve: Curve
@export var _instability_multiplier := 0.3
@export var _instability_per_layer := 0.05

@export var _building_instability_storage: BuildingInstabilityStorage

var _layers_on_basement_count := 0

@onready var top_layer_shape: CollisionShape2D = $CollisionShape2D
@onready var top_layer: BricksLayer

@onready var _basement_position: Vector2 = top_layer_shape.position
@onready var _basement_width: float = top_layer_shape.shape.get_rect().size.x
@onready var _balance := 0.0


func _ready() -> void:
	_bricks_layers_signals_channel.layer_landed.connect(_append_layer)


func _append_layer(layer: BricksLayer) -> void:
	layer.reparent(self)
	var new_building_layer = layer.collision_shape.duplicate(true) as CollisionShape2D
	add_child(new_building_layer)
	new_building_layer.global_position = layer.collision_shape.global_position
	new_building_layer.disabled = false
	top_layer_shape = layer.collision_shape
	top_layer = layer
	
	_layers_on_basement_count += 1
	
	_apply_top_layer_balance_impact()
	_building_instability_storage.set_value("instability", abs(_balance)
		+ _layers_on_basement_count * _instability_per_layer)


func _apply_top_layer_balance_impact() -> void:
	var top_layer_relative_position = top_layer_shape.global_position - global_position
	var offset = (_basement_position.x - top_layer_relative_position.x) / _basement_width
	var impact_force = _layer_offset_impact_curve.sample(abs(offset) * _instability_multiplier)
	
	_balance += impact_force if offset > 0 else -impact_force
