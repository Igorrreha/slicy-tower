class_name Brick
extends Area2D


var color: Color 


func paint(color: Color) -> void:
	self.color = color
	
	var gradient = Gradient.new()
	gradient.offsets = [0]
	gradient.colors = [color]
	
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.width = 100
	gradient_texture.height = 100
	gradient_texture.gradient = gradient
	$Sprite2D.texture = gradient_texture
