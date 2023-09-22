extends AnimationPlayer


@export var _building: Building
@export var _building_instability_storage: BuildingInstabilityStorage
@export var _max_offset_delta := 200

@export var _loop_offset_curve: Curve
@export var _loop_position := 0.5
@export var _loop_duration := 2.2

@onready var _initial_position := _building.position


func _ready() -> void:
	_building_instability_storage.bind("instability", _on_building_instability_updated)
	play("idle", 0.5, 1 / _loop_duration)


func _on_building_instability_updated() -> void:
	var offset = _building.position.x - _initial_position.x
	var max_offset = _max_offset_delta * _building_instability_storage.instability
	
	var new_loop_position = _get_curve_x_by_y(_loop_offset_curve, offset / max_offset)
	seek(new_loop_position)


func _get_curve_x_by_y(curve: Curve, y: float) -> float:
	var offset_position = 0.5
	var iteration_part_size = 0.5
	for i in range(100):
		var offset_value = curve.sample(offset_position)
		
		if y == offset_value:
			return offset_position
		
		iteration_part_size /= 2
		offset_position += iteration_part_size * (1 if offset_value < y else -1)
	
	return offset_position


func _process(delta: float) -> void:
	var offset = (_max_offset_delta * _building_instability_storage.instability
		* _loop_offset_curve.sample(_loop_position))
	_building.position = _initial_position + Vector2(offset, 0)
