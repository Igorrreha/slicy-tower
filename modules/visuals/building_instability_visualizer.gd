extends AnimationPlayer


@export var _building: Building
@export var _building_instability_storage: BuildingInstabilityStorage
@export var _loop_offset_curve: Curve
@export var _delta_offset := 200

@export var _loop_position := 0.5

@onready var _initial_position := _building.position


func _ready() -> void:
	_building_instability_storage.bind("instability", _on_building_instability_updated)


func _on_building_instability_updated() -> void:
#	var max_offset = (_loop_offset_curve.sample(1.0)
#		* _delta_offset * _building_instability_storage.instability) * 2
#	var new_loop_position = (0 if _building.position == _initial_position
#		else max_offset / (_building.position.x - _initial_position.x) + 0.5)
#
#	print(new_loop_position)
#	stop(0)
#	play("idle", new_loop_position * get_animation("idle").length)
	pass


func _process(delta: float) -> void:
	var offset = (_loop_offset_curve.sample(_loop_position)
		* _delta_offset * _building_instability_storage.instability)
	_building.position = _initial_position + Vector2(offset, 0)
