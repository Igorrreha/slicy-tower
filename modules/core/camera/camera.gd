extends Camera2D


@export var _bricks_layers_signals_channel: BricksLayersSignalsChannel

@onready var _offset_to_building_top: Marker2D = $OffsetToBuildingTop


func _ready() -> void:
	_bricks_layers_signals_channel.layer_landed.connect(_on_bricks_layer_landed)


func _on_bricks_layer_landed(layer: BricksLayer) -> void:
	if layer.global_position.y - global_position.y > _offset_to_building_top.position.y:
		return
	
	var target_position = layer.global_position - _offset_to_building_top.position
	_move_to_postion(Vector2(global_position.x, target_position.y))


func _move_to_postion(target_position: Vector2) -> void:
	global_position = target_position
