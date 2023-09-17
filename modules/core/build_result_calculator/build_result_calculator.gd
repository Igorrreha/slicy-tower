extends Node


@export var _combo_calculator: BricksComboCalculator
@export var _bricks_layer_signals_channel: BricksLayersSignalsChannel
@export var _building: Building

@export var _scores_storage: ScoresStorage

@export var _perfect_accuracy_cap := 0.9


func _ready() -> void:
	_bricks_layer_signals_channel.layer_landed.connect(_on_bricks_layer_landed)


func _on_bricks_layer_landed(layer: BricksLayer) -> void:
	var building_accuracy = _calculate_building_accuracy(layer)
	if building_accuracy > _perfect_accuracy_cap:
		layer.global_position.x = _building.top_layer_shape.global_position.x
		
		var max_group_color = _combo_calculator.get_max_group_color_or_null()
		if not max_group_color:
			max_group_color = layer.bricks[0].color
		
		for brick in layer.bricks:
			brick.paint(max_group_color)
	
	_combo_calculator.calculate(layer.bricks)
	_scores_storage.set_value("scores", _scores_storage.scores
		+ _combo_calculator.get_groups_sizes_sum())


func _calculate_building_accuracy(layer: BricksLayer) -> float:
	var new_layer_center = layer.collision_shape.global_position
	var building_top_center_position = _building.top_layer_shape.global_position
	var build_offset = abs(building_top_center_position.x - new_layer_center.x)
	var max_offset = layer.collision_shape.shape.get_rect().size.x / 2
	return 1.0 - build_offset / max_offset
