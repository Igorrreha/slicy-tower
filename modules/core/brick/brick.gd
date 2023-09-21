class_name Brick
extends Area2D


@export var _textures_by_color: Dictionary
var color: Color

@onready var _sprite: Sprite2D = $Sprite2D


func paint(color: Color) -> void:
	if not _sprite:
		_sprite = $Sprite2D
	
	self.color = color
	_sprite.texture = _textures_by_color[color]
	_sprite.scale = Vector2(1, 1) * 70.0 / _sprite.texture.get_width()
