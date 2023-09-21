extends AnimationPlayer


@export var _building: Building
@export var _building_instability_storage: BuildingInstabilityStorage
@export var _max_offset_delta := 200

@export var _loop_position := 0.5
@export var _loop_duration := 2.2

@onready var _initial_position := _building.position


func _ready() -> void:
	_building_instability_storage.bind("instability", _on_building_instability_updated)
	play("idle", 0.5, 1 / _loop_duration)


func _on_building_instability_updated() -> void:
	var max_offset = _max_offset_delta * _building_instability_storage.instability
	var new_loop_position = (0.5 if _building.position == _initial_position
		else (_building.position.x - _initial_position.x) / max_offset / 2.0 + 0.5)
	
	seek(new_loop_position)


func _process(delta: float) -> void:
	var offset = (_max_offset_delta * _building_instability_storage.instability
		* _loop_position)
	_building.position = _initial_position + Vector2(offset, 0)
