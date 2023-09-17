extends Label


@export var _scores_storage: ScoresStorage


func _ready() -> void:
	_scores_storage.bind("scores", _on_scores_updated)
	_on_scores_updated()


func _on_scores_updated() -> void:
	text = str(_scores_storage.scores)
