extends Node2D

var _farmType: Global.FarmType = Global.FarmType.Empty
@onready var tileSprite: AnimatedSprite2D = get_node("TileSprite")

@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()

func updateTileImage():
	tileSprite.set_animation(str(_farmType))

# Called when the node enters the scene tree for the first time.
func _ready():
	tileSprite.play()
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
