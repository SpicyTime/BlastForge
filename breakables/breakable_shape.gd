extends Node2D
@export var sprite_texture: Texture2D = null
@export var shape_type: Enums.ShapeType = Enums.ShapeType.TRIANGLE
@export var shape_size: Enums.ShapeSize = Enums.ShapeSize.SMALL
@export var shape_color: Enums.ShapeColor = Enums.ShapeColor.RED

@onready var breakable_sprite: Sprite2D = $BreakableSprite
