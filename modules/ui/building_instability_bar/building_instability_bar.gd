extends TextureProgressBar


@export var _building_state: BuildingState


func _ready() -> void:
	_building_state.bind("instability", _on_building_instability_updated)


func _on_building_instability_updated() -> void:
	value = _building_state.instability
