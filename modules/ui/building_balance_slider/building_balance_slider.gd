extends HSlider


@export var _building_state: BuildingState
@export var _max_deflection_degrees: float = 30


func _ready() -> void:
	_building_state.bind("balance", _on_building_balance_updated)


func _on_building_balance_updated() -> void:
	value = _building_state.balance
	rotation_degrees = value * _max_deflection_degrees
