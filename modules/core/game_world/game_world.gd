class_name GameWorld
extends Node2D


signal game_over


func end_the_game() -> void:
	game_over.emit()
