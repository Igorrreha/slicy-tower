extends TextureProgressBar


@export var _building_instability_storage: BuildingInstabilityStorage


func _ready() -> void:
	_building_instability_storage.bind("instability", _on_building_instability_updated)


func _on_building_instability_updated() -> void:
	value = _building_instability_storage.instability
