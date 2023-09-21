extends Node


signal game_ended
signal game_started


@export var _game_world_tscn: PackedScene

@export var _scores_storage: ScoresStorage
@export var _building_instability_storage: BuildingInstabilityStorage

@onready var _game_world: GameWorld = $GameWorldContainer/GameWorld
@onready var _game_world_container: Node = $GameWorldContainer


func end_game() -> void:
	_on_game_ended()


func restart_game() -> void:
	_game_world.game_over.disconnect(_on_game_ended)
	_game_world.queue_free()
	
	_game_world = _game_world_tscn.instantiate()
	_game_world_container.add_child(_game_world)
	_game_world.game_over.connect(_on_game_ended)
	start_game()
	
	_building_instability_storage.set_value("instability", 0)
	_scores_storage.set_value("scores", 0)


func start_game() -> void:
	game_started.emit()


func _ready() -> void:
	_game_world.game_over.connect(_on_game_ended)


func _on_game_ended() -> void:
	game_ended.emit()
